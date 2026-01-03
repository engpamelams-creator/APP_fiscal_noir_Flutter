import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/core/errors/failure.dart';
import 'package:fiscal_noir/modules/scanner/domain/entities/receipt_entity.dart';
import 'package:fiscal_noir/modules/scanner/domain/repositories/scanner_repository.dart';

@injectable
class SaveReceiptUseCase {
  final ScannerRepository _repository;

  SaveReceiptUseCase(this._repository);

  Future<Either<Failure, ReceiptEntity>> call(String imagePath) async {
    return _repository.saveReceipt(imagePath);
  }
}
