// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/search/data/repositories/search_repository_impl.dart'
    as _i1017;
import '../../features/search/domain/repositories/i_search_repository.dart'
    as _i835;
import '../../features/search/domain/usecases/search_places_usecase.dart'
    as _i792;
import '../api/dio_client.dart' as _i861;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i861.DioClient>(() => _i861.DioClient());
    gh.lazySingleton<_i835.ISearchRepository>(
      () => _i1017.SearchRepositoryImpl(gh<_i861.DioClient>()),
    );
    gh.lazySingleton<_i792.SearchPlacesUseCase>(
      () => _i792.SearchPlacesUseCase(gh<_i835.ISearchRepository>()),
    );
    return this;
  }
}
