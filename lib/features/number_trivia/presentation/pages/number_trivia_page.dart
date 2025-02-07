import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia/injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display,dart';
import '../widgets/trivia_controls.dart';
import '../widgets/trivia_display.dart';


class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (context) => sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Top half
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is NumberTriviaLoading) {
                      return const LoadingWidget();
                    } else if (state is NumberTriviaLoaded) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    } else if (state is NumberTriviaError) {
                      return MessageDisplay(message: state.message);
                    }
                    return const MessageDisplay(message: 'Start searching!');
                    // return CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 20),
                // Bottom half
                const TriviaControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
