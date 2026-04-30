import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/features/favorites/data/repos/favorities_repo.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repo;
  FavoritesCubit(this.repo) : super(FavoritesInitial());
  Future<void> loadFavorites() async {
    emit(FavoritesLoading());

    try {
      final ads = await repo.getFavoriteAds();
      emit(FavoritesSuccess(ads));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
