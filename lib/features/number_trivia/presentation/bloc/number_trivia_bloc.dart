import 'package:dartz/dartz.dart';
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
    on<GetConcreteNumberTriviaEvent>(_onGetConcreteNumberTrivia);
    on<GetRandomNumberTriviaEvent>(_onGetRandomNumberTrivia);
  }

  Future<void> _onGetConcreteNumberTrivia(GetConcreteNumberTriviaEvent event,
      Emitter<NumberTriviaState> emit) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
      (failure) => emit(const NumberTriviaError(
          message: 'Invalid Input - Enter a positive integer')),
      (number) async {
        emit(NumberTriviaLoading());
        final result = await getConcreteNumberTrivia(Params(number: number));
        emit(_mapResultToState(result));
      },
    );
  }

  Future<void> _onGetRandomNumberTrivia(
      GetRandomNumberTriviaEvent event, Emitter<NumberTriviaState> emit) async {
    print('GetRandomNumberTriviaEvent received');
    emit(NumberTriviaLoading());
    final result = await getRandomNumberTrivia(NoParams());
    print('getRandomNumberTrivia called');
    emit(_mapResultToState(result));
    print('State emitted: ${_mapResultToState(result)}');
  
  }

  NumberTriviaState _mapResultToState(Either<Failure, NumberTrivia> result) {
    return result.fold(
      (failure) => NumberTriviaError(message: _mapFailureToMessage(failure)),
      (trivia) => NumberTriviaLoaded(trivia: trivia),
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
