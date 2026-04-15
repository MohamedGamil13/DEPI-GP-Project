import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/features/saved_services/data/models/saved_service_model.dart';

part 'saved_services_state.dart';

class SavedServicesCubit extends Cubit<SavedServicesState> {
  SavedServicesCubit() : super(SavedServicesInitial());
  List<SavedServiceModel> _mySavedServices = [];

  Future<void> fetchSavedServices() async {
    emit(SavedServicesLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));


      emit(SavedServicesLoaded(List.from(_mySavedServices)));
    } catch (e) {
      emit(SavedServicesError('Error fetching saved services: $e'));
    }
  }
  void toggleFavorite(SavedServiceModel service) {
    final isExist = _mySavedServices.any((element) => element.title == service.title);
    if (isExist) {
      _mySavedServices.removeWhere((element) => element.title == service.title);
    } else {
      _mySavedServices.add(service);
    }
     emit(SavedServicesLoaded(List.from(_mySavedServices)));
  }
}
