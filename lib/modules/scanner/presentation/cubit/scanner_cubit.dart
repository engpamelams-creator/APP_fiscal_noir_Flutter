import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/modules/scanner/domain/usecases/save_receipt_usecase.dart';
import 'package:fiscal_noir/modules/scanner/presentation/cubit/scanner_state.dart';

@injectable
class ScannerCubit extends Cubit<ScannerState> {
  final SaveReceiptUseCase _saveReceiptUseCase;

  ScannerCubit(this._saveReceiptUseCase) : super(ScannerInitial());

  Future<void> onImageCaptured(String imagePath) async {
    emit(ScannerLoading());

    final result = await _saveReceiptUseCase(imagePath);

    result.fold(
      (failure) => emit(ScannerError(failure.message)),
      (receipt) => emit(ScannerSuccess(receipt)),
    );
  }

  void reset() {
    emit(ScannerInitial());
  }
}
