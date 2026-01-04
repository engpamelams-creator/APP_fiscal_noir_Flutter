// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:uuid/uuid.dart' as _i5;

import '../../app_module.dart' as _i22;
import '../../modules/auth/domain/repositories/auth_repository.dart' as _i8;
import '../../modules/auth/domain/usecases/login_usecase.dart' as _i14;
import '../../modules/auth/domain/usecases/signup_usecase.dart' as _i17;
import '../../modules/auth/infra/datasources/auth_datasource.dart' as _i6;
import '../../modules/auth/infra/datasources/firebase_auth_datasource.dart'
    as _i7;
import '../../modules/auth/infra/repositories/auth_repository_impl.dart' as _i9;
import '../../modules/auth/presentation/cubit/auth_cubit.dart' as _i18;
import '../../modules/dashboard/domain/repositories/dashboard_repository.dart'
    as _i11;
import '../../modules/dashboard/domain/usecases/get_expenses_usecase.dart'
    as _i13;
import '../../modules/dashboard/infra/datasources/dashboard_datasource.dart'
    as _i10;
import '../../modules/dashboard/infra/repositories/dashboard_repository_impl.dart'
    as _i12;
import '../../modules/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i19;
import '../../modules/scanner/domain/repositories/scanner_repository.dart'
    as _i15;
import '../../modules/scanner/domain/usecases/save_receipt_usecase.dart'
    as _i20;
import '../../modules/scanner/infra/repositories/scanner_repository_impl.dart'
    as _i16;
import '../../modules/scanner/presentation/cubit/scanner_cubit.dart' as _i21;

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
    gh.lazySingleton<_i4.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i5.Uuid>(() => appModule.uuid);
    gh.lazySingleton<_i6.AuthDataSource>(
        () => _i7.FirebaseAuthDataSourceImpl(gh<_i4.FirebaseAuth>()));
    gh.lazySingleton<_i8.AuthRepository>(
        () => _i9.AuthRepositoryImpl(gh<_i6.AuthDataSource>()));
    gh.lazySingleton<_i10.DashboardDataSource>(
        () => _i10.MockDashboardDataSource(gh<_i5.Uuid>()));
    gh.lazySingleton<_i11.DashboardRepository>(
        () => _i12.DashboardRepositoryImpl(gh<_i10.DashboardDataSource>()));
    gh.factory<_i13.GetExpensesUseCase>(
        () => _i13.GetExpensesUseCase(gh<_i11.DashboardRepository>()));
    gh.factory<_i14.LoginUseCase>(
        () => _i14.LoginUseCase(gh<_i8.AuthRepository>()));
    gh.lazySingleton<_i15.ScannerRepository>(
        () => _i16.ScannerRepositoryImpl(gh<_i5.Uuid>()));
    gh.factory<_i17.SignUpUseCase>(
        () => _i17.SignUpUseCase(gh<_i8.AuthRepository>()));
    gh.factory<_i18.AuthCubit>(() => _i18.AuthCubit(
          gh<_i14.LoginUseCase>(),
          gh<_i17.SignUpUseCase>(),
        ));
    gh.factory<_i19.DashboardCubit>(
        () => _i19.DashboardCubit(gh<_i13.GetExpensesUseCase>()));
    gh.factory<_i20.SaveReceiptUseCase>(
        () => _i20.SaveReceiptUseCase(gh<_i15.ScannerRepository>()));
    gh.factory<_i21.ScannerCubit>(
        () => _i21.ScannerCubit(gh<_i20.SaveReceiptUseCase>()));
    return this;
  }
}

class _$AppModule extends _i22.AppModule {}
