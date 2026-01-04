import 'package:equatable/equatable.dart';

class ReceiptEntity extends Equatable {
  final String id;
  final String imagePath;
  final DateTime capturedAt;

  const ReceiptEntity({
    required this.id,
    required this.imagePath,
    required this.capturedAt,
  });

  @override
  List<Object?> get props => [id, imagePath, capturedAt];
}
