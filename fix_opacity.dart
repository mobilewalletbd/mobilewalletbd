import 'dart:io';

void main() {
  final dir = Directory('lib');
  int replacedCount = 0;

  if (dir.existsSync()) {
    final entities = dir.listSync(recursive: true);
    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.dart')) {
        String content = entity.readAsStringSync();

        final RegExp opacityRegExp = RegExp(r'\.withOpacity\(([^)]+)\)');
        final RegExp providerRefRegExp = RegExp(r'AutoDisposeProviderRef');

        bool changed = false;

        if (opacityRegExp.hasMatch(content)) {
          content = content.replaceAllMapped(opacityRegExp, (match) {
            final param = match.group(1);
            return '.withValues(alpha: $param)';
          });
          changed = true;
        }

        if (providerRefRegExp.hasMatch(content)) {
          content = content.replaceAll('AutoDisposeProviderRef', 'Ref');
          changed = true;
        }

        if (changed) {
          entity.writeAsStringSync(content);
          replacedCount++;
        }
      }
    }
  }
  print('Replaced deprecated warnings in $replacedCount files.');
}
