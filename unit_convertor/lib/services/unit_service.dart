import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:unit_convertor/model/unit_entity.dart';

import '../router/path_exporter.dart';

class UnitService {

  final List<String> funnyMessages = [
    "🤡 Oops! The server took a coffee break ☕",
    "😵 Math is confused. Please try again!",
    "🚨 Server said NOPE!",
    "🤖 I tried… the server didn’t.",
    "📡 Signal lost in the math universe!",
    "🧮 Calculator ran away!",
    "😴 Server is sleepy. Wake it up!",
    "💥 Something exploded… not literally!",
    "🙈 Even the server is embarrassed!",
    "🛠️ Under construction… by lazy robots!",
  ];

  String _getRandomFunnyMessage() {
    final random = Random();
    return funnyMessages[random.nextInt(funnyMessages.length)];
  }

  Future<Map<String, dynamic>> postUnitData(
      String baseURL, UnitEntity unitEntity) async {
    try {
      debugPrint("BODY : ${jsonEncode(unitEntity.toJson())}");

      final http.Response response = await http.post(
        Uri.parse(
          '${baseURL.isNotEmpty ? baseURL : 'http://192.168.2.13:7503'}/unit/convert',
        ),
        headers: {
          "Content-type": "application/json",
        },
        body: jsonEncode(unitEntity.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'result': _getRandomFunnyMessage(),
          'statusCode': response.statusCode,
        };
      }
    } on Object catch (e) {
      debugPrint("ERROR $e");
      return {
        'success': false,
        'result': _getRandomFunnyMessage(),
        'statusCode': 0,
      };
    }
  }
}
