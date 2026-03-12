part of 'ad_posting_cubit.dart';

@immutable
sealed class AdPostingState {}

final class AdPostingInitial extends AdPostingState {}
final class AdPostingLoading extends AdPostingState {}
final class AdPostingSuccess extends AdPostingState {}
final class AdPostingError extends AdPostingState {
  final String message;
  AdPostingError(this.message);
}
