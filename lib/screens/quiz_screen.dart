import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../theme.dart';

class QuizScreen extends StatefulWidget {
  final String lessonId;
  final int xpReward;

  QuizScreen({required this.lessonId, required this.xpReward});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _answered = false;

  // Mock quiz questions
  final List<Question> _questions = [
    Question(
      id: 'q1',
      question: 'What does Flutter use for UI development?',
      options: ['Widgets', 'Components', 'Elements', 'Modules'],
      correctAnswerIndex: 0,
      explanation: 'Flutter uses widgets as building blocks for UI.',
    ),
    Question(
      id: 'q2',
      question: 'Which language is used for Flutter development?',
      options: ['Java', 'Kotlin', 'Dart', 'Swift'],
      correctAnswerIndex: 2,
      explanation: 'Dart is the programming language used in Flutter.',
    ),
    Question(
      id: 'q3',
      question: 'What is the main benefit of Hot Reload?',
      options: [
        'Faster app performance',
        'Instant UI updates during development',
        'Better battery life',
        'Smaller app size',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Hot Reload allows developers to see changes instantly without restarting the app.',
    ),
  ];

  void _submitAnswer() {
    if (_selectedAnswerIndex == null) return;

    setState(() {
      _answered = true;
      if (_selectedAnswerIndex ==
          _questions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _answered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final passed = _score >= (_questions.length * 0.7); // 70% to pass

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(passed ? '🎉 Congratulations!' : '😔 Try Again'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You scored $_score out of ${_questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (passed)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+ ${widget.xpReward} XP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.yellow,
                  ),
                ),
              )
            else
              Text('You need at least 70% to pass'),
          ],
        ),
        actions: [
          if (!passed)
            TextButton(
              onPressed: () {
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                  _selectedAnswerIndex = null;
                  _answered = false;
                });
                Navigator.pop(context);
              },
              child: Text('Retry'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, passed);
            },
            child: Text(passed ? 'Continue' : 'Back'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Exit Quiz?'),
                content: Text('Your progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context, false);
                    },
                    child: Text('Exit'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    question.question,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  ...List.generate(question.options.length, (index) {
                    final isSelected = _selectedAnswerIndex == index;
                    final isCorrect = index == question.correctAnswerIndex;

                    Color? backgroundColor;
                    Color? borderColor;

                    if (_answered) {
                      if (isCorrect) {
                        backgroundColor = AppTheme.primaryGreen.withOpacity(
                          0.1,
                        );
                        borderColor = AppTheme.primaryGreen;
                      } else if (isSelected && !isCorrect) {
                        backgroundColor = AppTheme.red.withOpacity(0.1);
                        borderColor = AppTheme.red;
                      }
                    } else if (isSelected) {
                      backgroundColor = AppTheme.blue.withOpacity(0.1);
                      borderColor = AppTheme.blue;
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: _answered
                            ? null
                            : () {
                                setState(() {
                                  _selectedAnswerIndex = index;
                                });
                              },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor ?? Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: borderColor ?? Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              if (_answered)
                                Icon(
                                  isCorrect
                                      ? Icons.check_circle
                                      : (isSelected ? Icons.cancel : null),
                                  color: isCorrect
                                      ? AppTheme.primaryGreen
                                      : AppTheme.red,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (_answered && question.explanation != null) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('💡', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 8),
                              Text(
                                'Explanation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(question.explanation!),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _answered
                    ? _nextQuestion
                    : (_selectedAnswerIndex != null ? _submitAnswer : null),
                child: Text(
                  _answered
                      ? (_currentQuestionIndex < _questions.length - 1
                            ? 'Next Question'
                            : 'Finish Quiz')
                      : 'Submit Answer',
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
