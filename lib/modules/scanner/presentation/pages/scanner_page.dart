import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiscal_noir/core/theme/app_colors.dart';
import 'package:fiscal_noir/modules/scanner/presentation/cubit/scanner_cubit.dart';
import 'package:fiscal_noir/modules/scanner/presentation/cubit/scanner_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _cubit = GetIt.I<ScannerCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocConsumer<ScannerCubit, ScannerState>(
        listener: (context, state) {
          if (state is ScannerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Receipt Captured: ${state.receipt.id}'),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
            // In a real app, we might navigate to a "Details" page here.
            // For now, let's just reset to allow another capture.
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) _cubit.reset();
            });
          } else if (state is ScannerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is ScannerLoading) {
            return const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (state is ScannerSuccess) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.primary, size: 64),
                    const SizedBox(height: 16),
                    Text('PROCESSING...',
                        style:
                            GoogleFonts.poppins(color: AppColors.textPrimary)),
                  ],
                ),
              ),
            );
          }

          // Camera View
          return Scaffold(
            backgroundColor: AppColors.background,
            body: CameraAwesomeBuilder.awesome(
              saveConfig: SaveConfig.photo(
                pathBuilder: (sensors) async {
                  final directory = await getApplicationDocumentsDirectory();
                  return '${directory.path}/${const Uuid().v4()}.jpg';
                },
              ),
              enablePhysicalButton: true,
              flashMode: FlashMode.auto,
              aspectRatio: CameraAspectRatios.ratio_16_9,
              previewFit: CameraPreviewFit.cover,
              theme: AwesomeTheme(
                bottomActionsBackgroundColor:
                    AppColors.background.withOpacity(0.5),
                buttonTheme: AwesomeButtonTheme(
                  backgroundColor: AppColors.surface,
                  iconSize: 32,
                  padding: const EdgeInsets.all(16),
                  foregroundColor: AppColors.primary,
                ),
              ),
              onMediaTap: (mediaCapture) {
                // Open gallery?
              },
              onMediaCaptureEvent: (event) {
                if (event.status == MediaCaptureStatus.success &&
                    event.captureRequest
                            .when(single: (single) => single.file?.path) !=
                        null) {
                  final path = event.captureRequest
                      .when(single: (single) => single.file!.path);
                  if (path != null) {
                    _cubit.onImageCaptured(path);
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
