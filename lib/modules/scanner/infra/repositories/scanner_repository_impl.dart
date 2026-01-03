import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:fiscal_noir/core/errors/failure.dart';
import 'package:fiscal_noir/modules/scanner/domain/entities/receipt_entity.dart';
import 'package:fiscal_noir/modules/scanner/domain/repositories/scanner_repository.dart';

@LazySingleton(as: ScannerRepository)
class ScannerRepositoryImpl implements ScannerRepository {
  final Uuid _uuid;

  ScannerRepositoryImpl(this._uuid);

  @override
  Future<Either<Failure, ReceiptEntity>> saveReceipt(String imagePath) async {
    try {
      // Simulate processing time
      await Future.delayed(const Duration(seconds: 1));

      final receipt = ReceiptEntity(
        id: _uuid.v4(),
        imagePath: imagePath,
        capturedAt: DateTime.now(),
      );

      return Right(receipt);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
