import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import '../../../../helpers/teste_helper.mocks.dart';


void main() {
  late GetConcreteNumberTrivia usercase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late int tNumber;
  late NumberTrivia tNumberTrivia;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usercase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
    tNumber = 1;
    tNumberTrivia = const NumberTrivia(text: 'test', number: 1);
  });

  test('should get trivia for the number from the repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => Right(tNumberTrivia));
    //act
    var result = await usercase(Params(number: tNumber));
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
