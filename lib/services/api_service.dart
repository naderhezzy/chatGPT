// ignore_for_file: avoid_print, avoid_classes_with_only_static_members

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ai_bot/constants/api_constants.dart';

class ApiService {
  static Future<List> getModels() async {
    try {
      final response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse["error"] != null) {
        dev.log("${jsonResponse["error"]}");
      }

      return jsonResponse['data'];
    } catch (error) {
      dev.log("$error");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> sendMessage({
    required modelId,
    required prompt,
  }) async {
    try {
      final Response response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          "model": modelId,
          "messages": [
            {"role": "user", "content": "$prompt"}
          ],
          "temperature": 0,
        }),
      );

      debugPrint(modelId);

      debugPrint(response.statusCode.toString());
      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse["error"] != null) {
        debugPrint("${jsonResponse["error"]}");
      }

      dev.log('${response.statusCode}');
      debugPrint('$jsonResponse');

      Map<String, dynamic> botAnswer = {
        'body': jsonResponse['choices'].toList().first['message']['content'],
        'isBotMessage': true,
      };

      return botAnswer;
    } catch (error) {
      dev.log('$error');
    }
    return null;
  }
}
