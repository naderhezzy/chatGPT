class Message {
  final String body;
  final bool isBotMessage;

  Message({
    required this.body,
    required this.isBotMessage,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        body: json['body'],
        isBotMessage: json['isBotMessage'],
      );

  Map<String, dynamic> toJson() => {
        'body': body,
        'isBotMessage': isBotMessage,
      };
}
