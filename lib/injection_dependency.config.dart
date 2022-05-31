// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import 'core/instances/firebase_injectable_module.dart' as _i14;
import 'core/preferences/preferences.dart' as _i12;
import 'data/datasources/class_abstract/user_remote_datasource.dart' as _i7;
import 'data/datasources/user/user_remote_datasource.dart' as _i8;
import 'data/repository/user_repository_impl.dart' as _i10;
import 'domain/repositories/user_repository.dart' as _i9;
import 'domain/usecase/get_user.dart' as _i11;
import 'presentation/blocs/authBloc/auth_bloc.dart' as _i13;
import 'presentation/blocs/myuser_controller.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  gh.lazySingleton<_i3.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i4.FirebaseFirestore>(
      () => firebaseInjectableModule.firebaseFirestore);
  gh.lazySingleton<_i5.MyUserData>(() => _i5.MyUserData());
  await gh.factoryAsync<_i6.SharedPreferences>(
      () => firebaseInjectableModule.prefs,
      preResolve: true);
  gh.lazySingleton<_i7.UserRemoteDataSource>(() => _i8.UserRemoteDataSourceImpl(
      auth: get<_i3.FirebaseAuth>(), db: get<_i4.FirebaseFirestore>()));
  gh.lazySingleton<_i9.UserRepository>(() => _i10.UserRepositpryImpl(
      remoteDataSource: get<_i7.UserRemoteDataSource>()));
  gh.lazySingleton<_i11.GetUser>(
      () => _i11.GetUser(userRepository: get<_i9.UserRepository>()));
  gh.factory<_i12.Preferences>(
      () => _i12.Preferences(preferences: get<_i6.SharedPreferences>()));
  gh.factory<_i13.AuthBloc>(() => _i13.AuthBloc(getUser: get<_i11.GetUser>()));
  return get;
}

class _$FirebaseInjectableModule extends _i14.FirebaseInjectableModule {}
