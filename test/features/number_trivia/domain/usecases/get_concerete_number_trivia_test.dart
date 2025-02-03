import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_concerete_number_trivia.dart';

import 'get_concerete_number_trivia_test.mocks.dart';

// class MockNumberTriviaRepository extends Mock implements NumberTriviaRepo {}
@GenerateMocks( [NumberTriviaRepo])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepo mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepo();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: tNumber, text: 'test trivia');

  test('should get trivia for the number from the repository', () async {
    // print((mockNumberTriviaRepository.getConcreteNumberTrivia(1)));
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async {
      return Right(tNumberTrivia);
    });

    // act
    final result = await usecase(Params(number: tNumber));

    // assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
