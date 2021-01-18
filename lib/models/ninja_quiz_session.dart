import 'dart:async';

import 'package:quiz/models/question_repository.dart';
import 'package:quiz/models/quiz_session.dart';

class NinjaQuizSession extends QuizSession {
  static const sessionDuration = Duration(seconds: 30);
  static const _questionDuration = Duration(seconds: 1);
  Timer _sessionTimer;
  Timer _questionTimer;

  NinjaQuizSession({QuestionRepository questionRepository})
      : super(questionRepository: questionRepository, totalQuestionCount: 2) {
    _sessionTimer = Timer(sessionDuration, endSession);
  }

  bool checkAnswer(String answer) {
    var correct = super.checkAnswer(answer);
    if (correct) {
      theScore++;
      nextQuestion();
    } else {
      theScore--;
    }
    return correct;
  }

  void endSession() {
    theState = QuizSessionState.finished;
    notifyListeners();
  }

  void startQuestionTimer() {
    print("starting question timer");
    _questionTimer = Timer(_questionDuration, stopQuestion);
  }

  void stopQuestion() {
    nextQuestion();
  }

  void nextQuestion() async {
    await super.nextQuestion();
    if (theState == QuizSessionState.showing) {
      startQuestionTimer();
    }
  }
}
