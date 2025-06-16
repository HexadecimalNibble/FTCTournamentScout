import './classes.dart';

class Team {
  const Team({
    required this.number,
    required this.name,
    required this.opr,
    required this.matches,
    this.updates = const [],
    this.news = const [],
  });

  final String number;
  final String name;
  final double opr;
  final List<Match> matches;
  final List<String> updates;
  final List<News> news;
}
