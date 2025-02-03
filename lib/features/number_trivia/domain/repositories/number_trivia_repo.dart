import 'package:dartz/dartz.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/errors/error.dart';

abstract class NumberTriviaRepo {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}




