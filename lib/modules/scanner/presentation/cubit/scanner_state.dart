import 'package:equatable/equatable.dart';
import 'package:fiscal_noir/modules/scanner/domain/entities/receipt_entity.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

class ScannerInitial extends ScannerState {}

class ScannerLoading extends ScannerState {}

class ScannerSuccess extends ScannerState {
  final ReceiptEntity receipt;
  const ScannerSuccess(this.receipt);

  @override
  List<Object?> get props => [receipt];
}

class ScannerError extends ScannerState {
  final String message;
  const ScannerError(this.message);

  @override
  List<Object?> get props => [message];
}
