import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/models/ninja_quiz_session.dart';
import 'package:quiz/models/question_repository.dart';
import 'package:quiz/models/remote_question_repository.dart';

import 'package:quiz/models/quiz_session.dart';
import 'package:quiz/models/rookie_quiz_session.dart';

enum QuizCategory {
  rookie,
  ninja,
}

class GameScreen extends StatelessWidget {
  final QuizCategory quizCategory;

  GameScreen({Key key, @required this.quizCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionRepository questionRepository = new StaticQuestionRepository();
    QuizSession session;

    switch (quizCategory) {
      case QuizCategory.rookie:
        session = RookieQuizSession(questionRepository: questionRepository);
        break;
      case QuizCategory.ninja:
        session = NinjaQuizSession(questionRepository: questionRepository);
        break;
    }

    //QuizSession session = SimpleQuizSession(questionRepository: new RemoteQuestionRepository("http://10.0.2.2:4567/questions/next"));
    session.nextQuestion();

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
      ),
      body: ChangeNotifierProvider.value(
        value: session,
        child: Consumer<QuizSession>(
          builder: (consumerContext, session, __) {
            switch (session.state) {
              case QuizSessionState.starting:
              case QuizSessionState.loading:
                return buildLoading(consumerContext);
              case QuizSessionState.error:
                return buildError(consumerContext, session);
              case QuizSessionState.showing:
                return buildQuestion(consumerContext, session);
              case QuizSessionState.finished:
                return buildGameEnded(consumerContext, session);
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  Widget buildError(BuildContext context, QuizSession session) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Sorry, something went wrong while grabbing the next question",
              textScaleFactor: 2.0),
          ElevatedButton(
            onPressed: () => session.nextQuestion(),
            child: Text("Retry",
                textScaleFactor: 2.0, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget buildQuestion(BuildContext context, QuizSession session) {
    var question = session.currentQuestion;
    var answerButtons = question.answers.map((answer) {
      return ElevatedButton(
          onPressed: () {
            session.checkAnswer(answer);
          },
          child: SizedBox(
              width: double.infinity,
              child: Text(answer,
                  textScaleFactor: 2.0, textAlign: TextAlign.center)));
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildHint(context, session),
          Text(question.caption, textScaleFactor: 2.0),
          ...answerButtons,
        ],
      ),
    );
  }

  Widget buildHint(BuildContext context, QuizSession session) {
    if (session.hintRequested) {
      return Text(session.currentQuestion.hint, textScaleFactor: 2.0);
    } else {
      return ElevatedButton(
        onPressed: () {
          session.requestHint();
        },
        child: Text("?", textScaleFactor: 2.0, textAlign: TextAlign.center),
      );
    }
  }

  Widget buildGameEnded(BuildContext context, QuizSession session) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("GAME OVER", textScaleFactor: 2.0),
          Text("${session.score} / ${session.questionsCount}",
              textScaleFactor: 2.0),
          ElevatedButton(
            onPressed: () {
              // This is currently a cheating hack because we know we are the home screen!
              // Navigator.pushReplacementNamed(context, "/");
              Navigator.pop(context);
            },
            child: Text("Restart",
                textScaleFactor: 2.0, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
