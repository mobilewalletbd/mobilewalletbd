import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for interacting with Cloudinary for media storage.
class CloudinaryService {
  late final Cloudinary cloudinary;

  CloudinaryService() {
    final cloudName = dotenv.get('CLOUDINARY_CLOUD_NAME');
    // Using fromCloudName for client-side usage (usually unsigned uploads)
    // If signed needed later, we can revisit, but avoiding 'full' for now.
    cloudinary = Cloudinary.fromCloudName(cloudName: cloudName);
  }

  // Add upload methods as needed for Phase 4/5
}

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});
