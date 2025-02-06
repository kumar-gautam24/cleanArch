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
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    test(
      'should emit [NumberTriviaLoading, NumberTriviaLoaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );
    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        // assert later
        final expected = [
          NumberTriviaError(
              message: 'Invalid Input - Enter a positive integer'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );
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

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async{
          // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
              .thenAnswer((_) async => Right(tNumberTrivia));

          // assert later
          final expected = [
            NumberTriviaLoading(),
            NumberTriviaLoaded(trivia: tNumberTrivia),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          // act
          bloc.add(GetConcreteNumberTriviaEvent(tNumberString));

        });

    test(
      'should emit [NumberTriviaLoading, NumberTriviaError] when getting data fails',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaError(message: 'Server Failure'), // Ensure this matches
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );
  });
}
