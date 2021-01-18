import 'package:quiz/models/question_repository.dart';
import 'package:quiz/models/quiz_session.dart';

class RookieQuizSession extends QuizSession {
  RookieQuizSession({QuestionRepository questionRepository})
      : super(questionRepository: questionRepository, totalQuestionCount: 3);

  bool checkAnswer(String answer) {
    var correct = super.checkAnswer(answer);
    if (correct) {
      theScore++;
    }
    nextQuestion();
    return correct;
  }
}
