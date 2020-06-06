
class LearnQuestionAnswer
{
  String question;
  List<LearnQuestionAnswer>answers;
  String questionId;
  bool isRead;


  LearnQuestionAnswer(this.question,[this.answers = const <LearnQuestionAnswer>[]]);

}
final List<LearnQuestionAnswer> data = <LearnQuestionAnswer>[
  LearnQuestionAnswer(
    'Qusetion 1',
    <LearnQuestionAnswer>[
      LearnQuestionAnswer( 'point 1 '),
      LearnQuestionAnswer('point 2'),
      LearnQuestionAnswer('point 3'),
    ],
  ),

];

