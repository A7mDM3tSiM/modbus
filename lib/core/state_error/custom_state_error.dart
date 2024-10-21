import 'package:equatable/equatable.dart';

class CustomStateError extends Equatable {
  final bool hasError;
  final String? message;

  const CustomStateError({required this.hasError, this.message});

  @override
  List<Object?> get props => [hasError, message];
}
