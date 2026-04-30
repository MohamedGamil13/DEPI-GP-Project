part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final List<AdModel> ads;
  FavoritesSuccess(this.ads);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}
