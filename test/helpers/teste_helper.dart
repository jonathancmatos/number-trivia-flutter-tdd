import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  NumberTriviaRepository,
  NumberTriviaLocalDataSource,
  NumberTriviaRemoteDataSource,
  NetworkInfo,
  InternetConnectionChecker,
  SharedPreferences,
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])

void main() {}