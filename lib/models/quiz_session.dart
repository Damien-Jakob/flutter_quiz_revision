import 'package:flutter/foundation.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/question_repository.dart';

enum QuizSessionState {
  starting,
  showing,
  loading,
  error,
  finished,
}

class QuizSession with ChangeNotifier {
  var _questionRepository;
  var _totalQuestionCount;
  var _currentQuestionCount = 0;

  // There's no `protected` visibility on Dart, so set it back to public!
  //https://stackoverflow.com/questions/28350655/how-do-i-emulate-protected-methods-in-dart
  var theScore =
      0; // should never be accessed from the outside except from subclasses
  var theState; // should never be accessed from the outside except from subclasses

  var _hintRequested = false;

  Question _currentQuestion;

  QuizSessionState get state => theState;
  Question get currentQuestion => _currentQuestion;
  int get questionsCount => _totalQuestionCount;
  int get score => theScore;
  bool get hintRequested => _hintRequested;

  QuizSession(
      {QuestionRepository questionRepository,
      @required int totalQuestionCount}) {
    _questionRepository = questionRepository;
    _totalQuestionCount = totalQuestionCount;
    theState = QuizSessionState.starting;
  }

  void nextQuestion() async {
    _hintRequested = false;

    try {
      _currentQuestionCount++;
      if (_currentQuestionCount > _totalQuestionCount) {
        _currentQuestion = null;
        theState = QuizSessionState.finished;
      } else {
        theState = QuizSessionState.loading;
        notifyListeners();
        _currentQuestion = await _questionRepository.fetch();
        theState = QuizSessionState.showing;
      }
    } catch (error) {
      theState = QuizSessionState.error;
    }

    notifyListeners();
  }

  bool checkAnswer(String answer) {
    return currentQuestion.isCorrectAnswer(answer);
  }

  void requestHint() {
    _hintRequested = true;
    notifyListeners();
  }
}
