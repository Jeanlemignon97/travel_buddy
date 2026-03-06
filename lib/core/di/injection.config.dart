// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/i_auth_repository.dart'
    as _i589;
import '../../features/itinerary/data/repositories/itinerary_repository_impl.dart'
    as _i775;
import '../../features/itinerary/domain/repositories/i_itinerary_repository.dart'
    as _i876;
import '../../features/search/data/repositories/search_repository_impl.dart'
    as _i1017;
import '../../features/search/domain/repositories/i_search_repository.dart'
    as _i835;
import '../../features/search/domain/usecases/search_places_usecase.dart'
    as _i792;
import '../api/dio_client.dart' as _i861;
import '../notifications/notification_service.dart' as _i229;
import 'firebase_module.dart' as _i616;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.singleton<_i861.DioClient>(() => _i861.DioClient());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i892.FirebaseMessaging>(() => firebaseModule.messaging);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.singleton<_i229.NotificationService>(
      () => _i229.NotificationService(gh<_i892.FirebaseMessaging>()),
    );
    gh.lazySingleton<_i835.ISearchRepository>(
      () => _i1017.SearchRepositoryImpl(gh<_i861.DioClient>()),
    );
    gh.lazySingleton<_i792.SearchPlacesUseCase>(
      () => _i792.SearchPlacesUseCase(gh<_i835.ISearchRepository>()),
    );
    gh.lazySingleton<_i876.IItineraryRepository>(
      () => _i775.ItineraryRepositoryImpl(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i589.IAuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i59.FirebaseAuth>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}
