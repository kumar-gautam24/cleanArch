// ignore_for_file: type_literal_in_constant_pattern

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia/core/errors/error.dart';

import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concerete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<GetConcreteNumberTriviaEvent>(_onGetTriviaForConcreteNumber);
    on<GetRandomNumberTriviaEvent>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
    GetConcreteNumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaLoading());
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    await inputEither.fold(
      (failure) async {
        emit(const NumberTriviaError(message: 'Invalid Input'));
      },
      (integer) async {
        final result = await getConcreteNumberTrivia(Params(number: integer));
        await result.fold(
          (failure) async {
            emit(NumberTriviaError(message: _mapFailureToMessage(failure)));
          },
          (trivia) async {
            emit(NumberTriviaLoaded(trivia: trivia));
          },
        );
      },
    );
  }

  Future<void> _onGetTriviaForRandomNumber(
    GetRandomNumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaLoading());
    final result = await getRandomNumberTrivia(NoParams());
    await result.fold(
      (failure) async {
        emit(NumberTriviaError(message: _mapFailureToMessage(failure)));
      },
      (trivia) async {
        emit(NumberTriviaLoaded(trivia: trivia));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
