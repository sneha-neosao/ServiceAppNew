import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import '../../configs/injector/injector.dart';
import '../../core/api/api_exception.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/failure_converter.dart';
import '../datasource/auth_remote_datasource.dart';

/// Abstract Repository interface defining all data operations for the app

abstract class Repository {

}

class AuthRepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const AuthRepositoryImpl(this._remoteDataSource, this._networkInfo);

}
