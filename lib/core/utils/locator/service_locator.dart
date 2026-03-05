import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skillbridge/core/utils/services/firebase_auth_service.dart';
import 'package:skillbridge/core/utils/services/firebase_auth_service_repo.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';

GetIt getIt =
    GetIt.instance; //take an intance from get_it => i use this package for DI

void setupLocator() {
  //for firebase auth instance => used in AuthService
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //for authService instance => used in auth repo
  getIt.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(getIt<FirebaseAuth>()),
  );
  //for auth repo => used in cubit
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImplementation(authService: getIt<AuthService>()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));
}
//our flow => auth methods(firebase or something else) >  AuthService(deal with any authsevice from any source) => Auth repo(deal with authService only) => Auth cubit(deal with repo only) => UI
//and this flow will be implemented for any another service 
