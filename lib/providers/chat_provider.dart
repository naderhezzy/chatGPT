import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ai_bot/models/message.dart';
import 'package:ai_bot/models/conversation.dart';
import 'package:ai_bot/services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  final List<Message> _chatList = [];
  List<Message> get chatList => _chatList;

  final List<Conversation> _savedConversations = [];
  List<Conversation> get savedConversations => _savedConversations;

  bool _isWrting = false;
  bool get isWriting => _isWrting;

  void setIsWriting({required bool stillWriting}) {
    _isWrting = stillWriting;
    notifyListeners();
  }

  Future<void> sendMessage({
    required String prompt,
    required String model,
  }) async {
    _chatList.add(Message.fromJson({'body': prompt, 'isBotMessage': false}));

    setIsWriting(stillWriting: true);

    final Map<String, dynamic>? botAnswer = await ApiService.sendMessage(
      modelId: model,
      prompt: prompt,
    );

    final message = Message.fromJson(botAnswer!);
    _chatList.add(message);

    final conversation = Conversation(
      id: UniqueKey().toString(),
      name: message.body,
      messages: List.generate(_chatList.length, (index) => _chatList[index]),
    );

    await saveConversation(conversation);

    notifyListeners();
  }

  Future<void> saveConversation(Conversation newConversation) async {
    final allConversations = await loadConversations();
    allConversations!.add(newConversation);

    await storage.write(
      key: 'aiConversations',
      value: jsonEncode(allConversations),
    );
  }

  Future<List<Conversation>?> loadConversations() async {
    final storedConversations = await storage.read(key: 'aiConversations');
    // if (storedConversations == null) {
    //   return null;
    // }

    final conversations = jsonDecode(storedConversations!)
        .map((conversation) => Conversation.fromJson(conversation));
    return conversations;
  }
}
