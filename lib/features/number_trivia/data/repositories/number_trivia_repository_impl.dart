import 'package:dartz/dartz.dart';

import 'package:trivia/core/errors/error.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/paltform/network_info.dart';
import '../../domain/repositories/number_trivia_repo.dart';
import '../datasources/number_trivia_remote_data_source.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepo {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
