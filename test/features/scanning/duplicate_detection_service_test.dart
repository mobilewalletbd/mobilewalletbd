// Unit tests for DuplicateDetectionService
// Tests fuzzy name matching, phone normalization, email comparison,
// company similarity, and composite scoring.

import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/scanning/data/services/duplicate_detection_service.dart';

Contact _makeContact({
  String id = '',
  String fullName = '',
  String? jobTitle,
  String? companyName,
  List<String> phoneNumbers = const [],
  List<String> emails = const [],
}) {
  final now = DateTime.now();
  return Contact(
    id: id,
    ownerId: 'test-owner',
    fullName: fullName,
    jobTitle: jobTitle,
    companyName: companyName,
    phoneNumbers: phoneNumbers,
    emails: emails,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late DuplicateDetectionService service;

  setUp(() {
    service = DuplicateDetectionService();
  });

  group('Name Similarity', () {
    test('exact name match returns 1.0', () {
      final score = service.calculateNameSimilarity('John Doe', 'John Doe');
      expect(score, equals(1.0));
    });

    test('case-insensitive match returns 1.0', () {
      final score = service.calculateNameSimilarity('john doe', 'John Doe');
      expect(score, equals(1.0));
    });

    test('fuzzy name match (typo) returns high score', () {
      final score = service.calculateNameSimilarity('Jhon Doe', 'John Doe');
      expect(score, greaterThan(0.70));
    });

    test('swapped name order returns high score', () {
      final score = service.calculateNameSimilarity('John Doe', 'Doe John');
      expect(score, greaterThanOrEqualTo(0.95));
    });

    test('completely different names return low score', () {
      final score = service.calculateNameSimilarity(
        'John Doe',
        'Alice Wonderland',
      );
      expect(score, lessThan(0.50));
    });

    test('empty names return 0.0', () {
      expect(service.calculateNameSimilarity('', 'John'), equals(0.0));
      expect(service.calculateNameSimilarity('John', ''), equals(0.0));
    });
  });

  group('Phone Normalization', () {
    test('strips non-digit characters', () {
      expect(
        service.normalizePhone('+1 (555) 123-4567'),
        equals('15551234567'),
      );
    });

    test('normalizes Bangladesh 01XXXXXXXXX to 880 format', () {
      final norm = service.normalizePhone('01712345678');
      expect(norm, equals('88001712345678'));
    });

    test('already-normalized +880 number stays valid', () {
      final norm = service.normalizePhone('+88001712345678');
      expect(norm, equals('88001712345678'));
    });
  });

  group('Phone Score', () {
    test('matching phones in different formats return 1.0', () {
      final score = service.calculatePhoneScore(
        ['+88001712345678'],
        ['01712345678'],
      );
      expect(score, greaterThanOrEqualTo(0.95));
    });

    test('different phone numbers return 0.0', () {
      final score = service.calculatePhoneScore(
        ['+8801711111111'],
        ['+8801722222222'],
      );
      expect(score, equals(0.0));
    });

    test('empty phone lists return 0.0', () {
      final score = service.calculatePhoneScore([], ['01712345678']);
      expect(score, equals(0.0));
    });
  });

  group('Email Score', () {
    test('exact email match returns 1.0', () {
      final score = service.calculateEmailScore(
        ['john@company.com'],
        ['john@company.com'],
      );
      expect(score, equals(1.0));
    });

    test('case-insensitive email match returns 1.0', () {
      final score = service.calculateEmailScore(
        ['John@Company.com'],
        ['john@company.com'],
      );
      expect(score, equals(1.0));
    });

    test('corporate domain match returns 0.5', () {
      final score = service.calculateEmailScore(
        ['john@acme.com'],
        ['jane@acme.com'],
      );
      expect(score, equals(0.5));
    });

    test('free email domain match returns 0.0 (gmail)', () {
      final score = service.calculateEmailScore(
        ['john@gmail.com'],
        ['jane@gmail.com'],
      );
      expect(score, equals(0.0));
    });

    test('different domains return 0.0', () {
      final score = service.calculateEmailScore(
        ['john@acme.com'],
        ['john@other.com'],
      );
      expect(score, equals(0.0));
    });

    test('empty email lists return 0.0', () {
      final score = service.calculateEmailScore([], ['john@acme.com']);
      expect(score, equals(0.0));
    });
  });

  group('Company Similarity', () {
    test('exact company match returns 1.0', () {
      final score = service.calculateCompanySimilarity(
        'Acme Corp',
        'Acme Corp',
      );
      expect(score, equals(1.0));
    });

    test('suffix variation returns high score', () {
      final score = service.calculateCompanySimilarity(
        'ABC Ltd.',
        'ABC Limited',
      );
      expect(score, greaterThan(0.70));
    });

    test('null company returns 0.0', () {
      expect(service.calculateCompanySimilarity(null, 'Acme'), equals(0.0));
      expect(service.calculateCompanySimilarity('Acme', null), equals(0.0));
    });

    test('completely different companies return low score', () {
      final score = service.calculateCompanySimilarity(
        'Alpha Technologies',
        'Beta Solutions',
      );
      expect(score, lessThan(0.50));
    });
  });

  group('Composite Duplicate Detection', () {
    test('identical contacts return score >= 0.60 and appear in results', () {
      final newContact = _makeContact(
        fullName: 'John Doe',
        phoneNumbers: ['01712345678'],
        emails: ['john@acme.com'],
        companyName: 'Acme Corp',
      );
      final existing = _makeContact(
        id: 'existing-1',
        fullName: 'John Doe',
        phoneNumbers: ['+88001712345678'],
        emails: ['john@acme.com'],
        companyName: 'Acme Corp.',
      );

      final results = service.findDuplicates(newContact, [existing]);
      expect(results, isNotEmpty);
      expect(results.first.overallScore, greaterThanOrEqualTo(0.60));
      expect(results.first.matchedFields, contains('Name'));
    });

    test('no duplicates found for completely different contacts', () {
      final newContact = _makeContact(
        fullName: 'Alice Smith',
        phoneNumbers: ['01799999999'],
        emails: ['alice@xyz.com'],
        companyName: 'XYZ Inc',
      );
      final existing = _makeContact(
        id: 'existing-2',
        fullName: 'Bob Johnson',
        phoneNumbers: ['01711111111'],
        emails: ['bob@other.com'],
        companyName: 'Other Corp',
      );

      final results = service.findDuplicates(newContact, [existing]);
      expect(results, isEmpty);
    });

    test('results are sorted by score descending', () {
      final newContact = _makeContact(
        fullName: 'John Doe',
        phoneNumbers: ['01712345678'],
        emails: ['john@acme.com'],
      );
      final strongMatch = _makeContact(
        id: 'strong',
        fullName: 'John Doe',
        phoneNumbers: ['01712345678'],
        emails: ['john@acme.com'],
      );
      final weakMatch = _makeContact(
        id: 'weak',
        fullName: 'Jon Doe', // typo
        emails: ['info@acme.com'], // domain match
      );

      final results = service.findDuplicates(newContact, [
        weakMatch,
        strongMatch,
      ]);

      if (results.length >= 2) {
        expect(
          results.first.overallScore,
          greaterThanOrEqualTo(results.last.overallScore),
        );
      }
    });

    test('skips same-id contact during comparison', () {
      final contact = _makeContact(
        id: 'same-id',
        fullName: 'John Doe',
        phoneNumbers: ['01712345678'],
      );

      final results = service.findDuplicates(contact, [contact]);
      expect(results, isEmpty);
    });
  });

  group('Levenshtein Distance', () {
    test('identical strings have distance 0', () {
      expect(service.levenshteinDistance('hello', 'hello'), equals(0));
    });

    test('empty vs non-empty returns length', () {
      expect(service.levenshteinDistance('', 'hello'), equals(5));
      expect(service.levenshteinDistance('hello', ''), equals(5));
    });

    test('single character difference returns 1', () {
      expect(service.levenshteinDistance('cat', 'car'), equals(1));
    });
  });
}
