import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import '../../../../injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Number Trivia"),
      ),
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context){
    return BlocProvider<NumberTriviaBloc>(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            const SizedBox(height: 10),
            //Top half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(message: 'Start searching');
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numbertrivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else {
                    return const SizedBox();
                  }
                }),
            const SizedBox(height: 20),
            //Bottom half
            const TriviaControls()
          ]),
        ),
      ),
    );
  }
}


