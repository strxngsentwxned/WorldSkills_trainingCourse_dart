import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: QuizApp()));
}

class Question {
  Question({required this.question, required this.answers});

  final String question;
  List<Answer> answers;
}

class Answer {
  Answer({required this.answer, required this.isCorrect});

  final String answer;
  final bool isCorrect;
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int currentIndex = 0;
  int correctCount = 0;
  bool isEnded = false;

  List<Question> questions = [
    Question(
      question: 'JavaScript 與 Java 有什麼關係？',
      answers: [
        Answer(answer: '同公司的產品', isCorrect: false),
        Answer(answer: '新版與舊版的關係', isCorrect: false),
        Answer(answer: '一點關係也沒有', isCorrect: true),
        Answer(answer: 'JavaScript 是 Java 的 Web 版', isCorrect: false),
      ],
    ),
    Question(
      question: '發明 React JS 的公司是？',
      answers: [
        Answer(answer: 'Google', isCorrect: false),
        Answer(answer: 'Facebook', isCorrect: true),
        Answer(answer: 'Apple', isCorrect: false),
        Answer(answer: 'Microsoft', isCorrect: false),
      ],
    ),
  ];

  void checkAnswer(int answerIndex) {
    bool isCorrect = questions[currentIndex].answers[answerIndex].isCorrect;

    if (isCorrect) {
      setState(() {
        correctCount++;
      });
    }

    if (currentIndex + 1 >= questions.length) {
      setState(() {
        isEnded = true;
      });
    } else {
      setState(() {
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Visibility(
        visible: !isEnded,
        replacement: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Completed!',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight(600)),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Your Score: ${correctCount / questions.length * 100}',
                  style: TextStyle(fontSize: 36),
                ),
                SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                      correctCount = 0;
                      isEnded = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(100),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Restart',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            spacing: 20.0,
            children: [
              Text(
                questions[currentIndex].question,
                style: TextStyle(fontSize: 48),
              ),
              for (int i = 0; i < questions[currentIndex].answers.length; i++)
                GestureDetector(
                  onTap: () {
                    checkAnswer(i);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(100),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      questions[currentIndex].answers[i].answer,
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
