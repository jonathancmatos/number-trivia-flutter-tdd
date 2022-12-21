import 'package:flutter/material.dart';
import '../../domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numbertrivia;

  const TriviaDisplay({super.key, required this.numbertrivia});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          // Fixed sizem doesn't scroll
          Text(
            numbertrivia.number.toString(),
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
          ),
          //Expanded makes it fill in all the remaining space
          Expanded(
              child: Center(
            child: SingleChildScrollView(
              child: Text(
                numbertrivia.text,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              )
            ),
          ))
        ],
      ),
    );
  }
}