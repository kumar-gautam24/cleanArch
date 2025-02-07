import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/execption.dart';
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
    try {
      if (kDebugMode) {
        print('Calling API for number: $number');
      } // Debug log
      final response = await client.get(
        'http://numbersapi.com/$number',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.json,
        ),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      } // Debug log
      if (kDebugMode) {
        print('Response data: ${response.data}');
      } // Debug log

      if (response.statusCode == 200) {
        return NumberTriviaModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioError: ${e.message}');
      } // Debug log
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    if (kDebugMode) {
      print('Calling API for random number');
    } // Debug log
    try {
      final response = await client.get(
        'http://numbersapi.com/random',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      } // Debug log
      if (kDebugMode) {
        print('Response data: ${response.data}');
      } //
      return NumberTriviaModel.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioError: ${e.message}');
      } // Debug log
      throw ServerException();
    }
  }
}
