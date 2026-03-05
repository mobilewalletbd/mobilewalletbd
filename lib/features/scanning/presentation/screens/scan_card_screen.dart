// Scan Card Screen
// Camera viewfinder with card alignment guide for business card scanning

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/scanning/domain/entities/scanned_card.dart';
import 'package:mobile_wallet/features/scanning/presentation/providers/scan_provider.dart';
import 'package:mobile_wallet/features/scanning/presentation/widgets/alignment_guide.dart';

/// Screen for scanning business cards using camera
class ScanCardScreen extends ConsumerStatefulWidget {
  const ScanCardScreen({super.key});

  @override
  ConsumerState<ScanCardScreen> createState() => _ScanCardScreenState();
}

class _ScanCardScreenState extends ConsumerState<ScanCardScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  String? _initError;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _initError = 'No cameras available';
        });
        return;
      }

      // Default to back camera
      _selectedCameraIndex = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
      );
      if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;

      await _startCamera(_cameras[_selectedCameraIndex]);
    } catch (e) {
      setState(() {
        _initError = 'Camera initialization failed: $e';
      });
    }
  }

  Future<void> _startCamera(CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller = controller;
    await controller.initialize();

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
      ref.read(scanNotifierProvider.notifier).cameraReady();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    await ref.read(scanNotifierProvider.notifier).captureCard(_controller!);

    // Check if we should proceed to preview or auto-save in batch mode
    final state = ref.read(scanNotifierProvider);

    if (state.hasFront && state.hasBack) {
      if (state.isBatchMode) {
        // Auto-save and stay on camera
        print('📸 [SCAN] Batch mode: Both sides captured, auto-processing...');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Processing card... Keep scanning!'),
            duration: Duration(seconds: 2),
          ),
        );
        // Process in background and keep scanning
        ref.read(scanNotifierProvider.notifier).processImages();

        // Reset state for next scan
        if (mounted) {
          ref.read(scanNotifierProvider.notifier).reset();
          // restore batch mode if it was reset
          if (!ref.read(scanNotifierProvider).isBatchMode) {
            ref.read(scanNotifierProvider.notifier).toggleBatchMode();
          }
        }
      } else {
        // Both sides captured, proceed automatically
        print('📸 [SCAN] Both sides captured, proceeding to preview');
        if (mounted) {
          _proceedToPreview();
        }
      }
    } else if (state.hasFront &&
        state.currentSide == CardSide.back &&
        !state.hasBack) {
      // Just finished front, on back side now, but haven't captured it yet
      print('📸 [SCAN] Front captured, prompt for back side');
      if (mounted) {
        if (state.isBatchMode) {
          // in batch mode just show a toast rather than a blocking dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Front captured. Scan back or skip.'),
              duration: Duration(seconds: 2),
            ),
          );
          // add a skip button to the UI if we want to skip back side in batch mode
        } else {
          _showBackSideDialog();
        }
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await ref
            .read(scanNotifierProvider.notifier)
            .processGalleryImage(image.path);

        // Check if we should proceed to preview
        final state = ref.read(scanNotifierProvider);
        if (state.hasFront && state.hasBack) {
          if (state.isBatchMode) {
            print(
              '📸 [SCAN] Batch mode: Both sides generated, auto-processing...',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Processing card... Keep scanning!'),
                duration: Duration(seconds: 2),
              ),
            );
            ref.read(scanNotifierProvider.notifier).processImages();

            if (mounted) {
              ref.read(scanNotifierProvider.notifier).reset();
              if (!ref.read(scanNotifierProvider).isBatchMode) {
                ref.read(scanNotifierProvider.notifier).toggleBatchMode();
              }
            }
          } else {
            if (mounted) {
              _proceedToPreview();
            }
          }
        } else if (state.hasFront && state.currentSide == CardSide.back) {
          if (mounted) {
            if (state.isBatchMode) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Front selected. Capture/Pick back or skip.'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              _showBackSideDialog();
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameras.isEmpty) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _startCamera(_cameras[_selectedCameraIndex]);
  }

  void _showBackSideDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Back Side?'),
        content: const Text(
          'Would you like to scan the back of the business card?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _proceedToPreview();
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Continue scanning for back
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Scan Back'),
          ),
        ],
      ),
    );
  }

  void _proceedToPreview() async {
    // Process images
    await ref.read(scanNotifierProvider.notifier).processImages();

    // Navigate to preview screen
    if (mounted) {
      context.push('/contacts/scan/preview');
    }
  }

  void _toggleFlash() async {
    if (_controller == null) return;

    ref.read(scanNotifierProvider.notifier).toggleFlash();
    final flashMode = ref.read(scanNotifierProvider).flashMode;

    try {
      await _controller!.setFlashMode(flashMode);
    } catch (e) {
      // Flash not supported
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isCameraInitialized && _controller != null)
            _buildCameraPreview()
          else if (_initError != null)
            _buildErrorView()
          else
            _buildLoadingView(),

          // Overlay
          _buildOverlay(scanState),

          // Flash Recommendation (Section 24.2)
          _buildFlashRecommendation(scanState),

          // Top bar
          _buildTopBar(scanState),

          // Bottom controls
          _buildBottomControls(scanState),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Positioned.fill(
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: CameraPreview(_controller!),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryGreen),
          SizedBox(height: 16),
          Text(
            'Initializing camera...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            Text(
              _initError ?? 'Camera error',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay(ScanState state) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Column(
          children: [
            // Top dark area
            Expanded(
              flex: 2,
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
            ),
            // Card alignment area
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                  // Card frame
                  const SizedBox(
                    width: 300,
                    height: 190,
                    child: CardAlignmentGuide(),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom dark area with instructions
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Batch Mode Toggle
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(scanNotifierProvider.notifier)
                              .toggleBatchMode();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: state.isBatchMode
                                ? AppColors.primaryGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: state.isBatchMode
                                  ? AppColors.primaryGreen
                                  : Colors.white54,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_mode,
                                color: state.isBatchMode
                                    ? Colors.white
                                    : Colors.white54,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Batch Mode',
                                style: TextStyle(
                                  color: state.isBatchMode
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.currentSide == CardSide.front
                            ? 'Position front of card in frame'
                            : 'Position back of card in frame',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ScanState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Close button
              IconButton(
                onPressed: () {
                  ref.read(scanNotifierProvider.notifier).reset();
                  context.pop();
                },
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
              const Spacer(),
              // Card side indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  state.currentSide == CardSide.front ? 'FRONT' : 'BACK',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // History button
              IconButton(
                onPressed: () {
                  context.pushNamed('scanHistory');
                },
                icon: const Icon(Icons.history, color: Colors.white, size: 28),
              ),
              const Spacer(),
              // Flash toggle
              IconButton(
                onPressed: _toggleFlash,
                icon: Icon(
                  _getFlashIcon(state.flashMode),
                  color: state.flashMode == FlashMode.always
                      ? AppColors.warmGold
                      : Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
      default:
        return Icons.flash_auto;
    }
  }

  Widget _buildFlashRecommendation(ScanState state) {
    if (!state.recommendFlash) return const SizedBox.shrink();

    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.warmGold, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.flash_on, color: AppColors.warmGold),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Low light detected. Try with flash?',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(scanNotifierProvider.notifier)
                    .setFlashMode(FlashMode.always);
                // Clear recommendation after action
                // In a real app we might want to state.copyWith(recommendFlash: false)
              },
              child: const Text(
                'ENABLE',
                style: TextStyle(
                  color: AppColors.warmGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(ScanState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery Button or Skip Button (Batch Mode, Back Side)
                  if (state.isBatchMode && state.currentSide == CardSide.back)
                    IconButton(
                      onPressed: () {
                        ref.read(scanNotifierProvider.notifier).skipBack();
                        ref.read(scanNotifierProvider.notifier).processImages();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Skipping back. Processing card...'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Reset state for next scan
                        if (mounted) {
                          ref.read(scanNotifierProvider.notifier).reset();
                          if (!ref.read(scanNotifierProvider).isBatchMode) {
                            ref
                                .read(scanNotifierProvider.notifier)
                                .toggleBatchMode();
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 32,
                      ),
                    )
                  else
                    IconButton(
                      onPressed: _pickFromGallery,
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                  // Capture button
                  GestureDetector(
                    onTap: _captureImage,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 4,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),

                  // Camera Flip
                  IconButton(
                    onPressed: _toggleCamera,
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Manual entry link
              TextButton(
                onPressed: () {
                  ref.read(scanNotifierProvider.notifier).reset();
                  context.go('/contacts/add');
                },
                child: const Text(
                  'Enter Manually Instead',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
