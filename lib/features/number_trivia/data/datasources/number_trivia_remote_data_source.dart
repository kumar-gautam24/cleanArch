import 'package:dio/dio.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Dio client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await client.get(
      'http://numbersapi.com/$number',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    return NumberTriviaModel.fromJson(response.data);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
