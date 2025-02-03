import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/core/paltform/network_info.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repo_impl_test.mocks.dart';


@GenerateMocks([
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo
])
void main() {
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
  });

  final repository = NumberTriviaRepositoryImpl(
    remoteDataSource: mockRemoteDataSource,
    localDataSource: mockLocalDataSource,
    networkInfo: mockNetworkInfo,
  );

  group("getConcerete number trivia", () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device is online', () {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      //assert 
      verify(mockNetworkInfo.isConnected);
    });
  });
}
