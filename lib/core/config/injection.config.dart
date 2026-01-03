// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:uuid/uuid.dart' as _i4;

import '../../app_module.dart' as _i14;
import '../../modules/auth/domain/repositories/auth_repository.dart' as _i6;
import '../../modules/auth/domain/usecases/login_usecase.dart' as _i8;
import '../../modules/auth/infra/datasources/auth_datasource.dart' as _i5;
import '../../modules/auth/infra/repositories/auth_repository_impl.dart' as _i7;
import '../../modules/auth/presentation/cubit/auth_cubit.dart' as _i11;
import '../../modules/scanner/domain/repositories/scanner_repository.dart'
    as _i9;
import '../../modules/scanner/domain/usecases/save_receipt_usecase.dart'
    as _i12;
import '../../modules/scanner/infra/repositories/scanner_repository_impl.dart'
    as _i10;
import '../../modules/scanner/presentation/cubit/scanner_cubit.dart' as _i13;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.lazySingleton<_i3.Dio>(() => appModule.dio);
    gh.lazySingleton<_i4.Uuid>(() => appModule.uuid);
    gh.lazySingleton<_i5.AuthDataSource>(
        () => _i5.MockAuthDataSource(gh<_i4.Uuid>()));
    gh.lazySingleton<_i6.AuthRepository>(
        () => _i7.AuthRepositoryImpl(gh<_i5.AuthDataSource>()));
    gh.factory<_i8.LoginUseCase>(
        () => _i8.LoginUseCase(gh<_i6.AuthRepository>()));
    gh.lazySingleton<_i9.ScannerRepository>(
        () => _i10.ScannerRepositoryImpl(gh<_i4.Uuid>()));
    gh.factory<_i11.AuthCubit>(() => _i11.AuthCubit(gh<_i8.LoginUseCase>()));
    gh.factory<_i12.SaveReceiptUseCase>(
        () => _i12.SaveReceiptUseCase(gh<_i9.ScannerRepository>()));
    gh.factory<_i13.ScannerCubit>(
        () => _i13.ScannerCubit(gh<_i12.SaveReceiptUseCase>()));
    return this;
  }
}

class _$AppModule extends _i14.AppModule {}
