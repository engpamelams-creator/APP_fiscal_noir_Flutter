import 'package:fpdart/fpdart.dart';
import 'package:fiscal_noir/core/errors/failure.dart';
import 'package:fiscal_noir/modules/scanner/domain/entities/receipt_entity.dart';

abstract class ScannerRepository {
  Future<Either<Failure, ReceiptEntity>> saveReceipt(String imagePath);
}
