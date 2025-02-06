import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockDio);
  });

  void setUpMockDioSuccess200() {
    when(
      mockDio.get(any, options: anyNamed('options')),
    ).thenAnswer(
      (_) async => Response(
        data: json.decode(fixture('trivia.json')),
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );
  }

  void setUpMockDioFailure404() {
    when(
      mockDio.get(any, options: anyNamed('options')),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      ),
    );
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number endpoint', () async {
      // arrange
      setUpMockDioSuccess200();
      // act
      await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockDio.get(
        'http://numbersapi.com/$tNumber',
        options: anyNamed('options'),
      ));
    });

    test('should return NumberTrivia when response code is 200', () async {
      // arrange
      setUpMockDioSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when response code is not 200', () async {
      // arrange
      setUpMockDioFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(isA<DioException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with random endpoint', () async {
      // arrange
      setUpMockDioSuccess200();
      // act
      await dataSource.getRandomNumberTrivia();
      // assert
      verify(mockDio.get(
        'http://numbersapi.com/random',
        options: anyNamed('options'),
      ));
    });

    test('should return NumberTrivia when response code is 200', () async {
      // arrange
      setUpMockDioSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when response code is not 200', () async {
      // arrange
      setUpMockDioFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA< DioException>()));
    });
  });
}