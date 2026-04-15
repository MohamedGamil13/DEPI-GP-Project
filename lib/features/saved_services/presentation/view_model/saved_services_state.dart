part of 'saved_services_cubit.dart';

@immutable
sealed class SavedServicesState {}

final class SavedServicesInitial extends SavedServicesState {}
class SavedServicesLoading extends SavedServicesState {}
class SavedServicesLoaded extends SavedServicesState {
  final List<SavedServiceModel> savedServices;

  SavedServicesLoaded(this.savedServices);
}
class SavedServicesError extends SavedServicesState {
  final String errorMessage;

  SavedServicesError(this.errorMessage);
}