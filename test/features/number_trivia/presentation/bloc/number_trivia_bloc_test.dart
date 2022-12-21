import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/usecases/usercase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../helpers/teste_helper.mocks.dart';

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
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    //assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    //The event takes in a String
    const tNumberString = '1';
    //This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    //NumberTrivia instance is needed too, of course
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      //assert later
      final expected = [
        Empty(),
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //assert Later
      final expected = [
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] whe getting data fails', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumver', (){
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random use case', () async{
      //arrange
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async*{
      //arrange
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => const Right(tNumberTrivia));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
  });

  test('should emit [Loading, Error] when getting data fails', () async*{
    //arrange
    when(mockGetRandomNumberTrivia(any))
      .thenAnswer((_) async => Left(ServerFailure()));
    //assert later 
    final expected = [
      Empty(),
      Loading(),
      const Error(message: SERVER_FAILURE_MESSAGE)
    ];
    expectLater(bloc.state, emitsInOrder(expected));
    //act
    bloc.add(GetTriviaForRandomNumber());
  });

  test('should emit [Loading, Error] with a proper message for the error when getting data fails', () async*{
    //arrange
    when(mockGetRandomNumberTrivia(any))
      .thenAnswer((_) async => Left(CacheFailure()));
    //assert later
    final expected = [
      Empty(),
      Loading(),
      const Error(message: CACHE_FAILURE_MESSAGE)
    ];
    expectLater(bloc.state, emitsInOrder(expected));
    //act
    bloc.add(GetTriviaForRandomNumber());
  });

}
