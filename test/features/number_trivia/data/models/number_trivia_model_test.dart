import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');

  //
  test('should be a subclass of NumberTrivia Entity', () {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("from Json number_trivia_model", () {
    test('should return a valid model when number is integer', () {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);

      // verify(NumberTriviaModel.fromJson(jsonMap));
    });

    test('should return Number trivia model when num is double', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);

      // verify(NumberTriviaModel.fromJson(jsonMap));
    });
  });

  group("toJson number_trivia_model", () {
    test('toJson with number as int', () {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedMap = {
        "text": "test",
        "number": 1,
      };
      expect(result, expectedMap);
    });
    
  });
}
