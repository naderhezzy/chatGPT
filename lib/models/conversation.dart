import 'package:ai_bot/models/message.dart';

class Conversation {
  final String id;
  final String name;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.name,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final List<dynamic> messagesJson = json['messages'];
    final List<Message> messages =
        messagesJson.map((message) => Message.fromJson(message)).toList();

    return Conversation(
      id: json['id'],
      name: json['name'],
      messages: messages,
    );
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> messagesJson =
        messages.map((message) => message.toJson()).toList();

    return {
      'id': id,
      'name': name,
      'messages': messagesJson,
    };
  }
}
