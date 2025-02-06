import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/core/errors/error.dart';
import 'package:trivia/core/utils/input_converter.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_concerete_number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initial state should be NumberTriviaInitial', () {
    expect(bloc.state, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from concrete use case',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // act
        bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
        await untilCalled(
            mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));

        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [NumberTriviaLoading, NumberTriviaLoaded] when data is gotten successfully',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );

    test(
      'should emit [NumberTriviaLoading, NumberTriviaError] when getting data fails',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          NumberTriviaLoading(),
          NumberTriviaError(message: 'Server Failure'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 123, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // Arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // Assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // Act
        bloc.add(GetRandomNumberTriviaEvent());
      },
    );


    test(
      'should emit [NumberTriviaLoading, NumberTriviaLoaded] when data is gotten successfully',
      () async {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        bloc.add(GetRandomNumberTriviaEvent());
      },
    );

    test(
      'should emit [NumberTriviaLoading, NumberTriviaError] when getting data fails',
      () async {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          NumberTriviaLoading(),
          NumberTriviaError(message: 'Server Failure'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        bloc.add(GetRandomNumberTriviaEvent());
      },
    );
  });
}
