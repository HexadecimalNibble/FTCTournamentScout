import 'dart:convert';
import 'package:http/http.dart' as http;

final apiKey = ""; // Set your API key here

Future<List<dynamic>> fetchTeams() async {
  final response = await http.get(
    Uri.parse('https://ftc-api.firstinspires.org/v2.0/2024/teams?state=AZ'),
    headers: {"Authorization": 'Basic $apiKey'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final teams = data['teams'] as List<dynamic>;
    return teams;
  } else {
    throw Exception('Failed to load teams. ${response.statusCode}');
  }
}

// TODO: CHECK THIS CODE
Future<List<dynamic>> fetchTeamOpr(String teamId) async {
  final response = await http.get(
    Uri.parse('https://ftc-api.firstinspires.org/v2.0/2024/teams/$teamId/opr'),
    headers: {"Authorization": 'Basic $apiKey'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final opr = data['opr'] as List<dynamic>;
    return opr;
  } else {
    throw Exception('Failed to load team OPR. ${response.statusCode}');
  }
}
