import 'package:ai_bot/constants/constants.dart';
import 'package:ai_bot/providers/chat_provider.dart';
import 'package:ai_bot/services/assets_manager.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    required this.message,
    required this.isBotMessage,
    super.key,
  });

  final String message;
  final bool isBotMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isBotMessage ? cardColor : scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  isBotMessage
                      ? AssetsManager.botImage
                      : AssetsManager.userImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: !isBotMessage
                      ? Text(
                          message.trim(),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 16),
                        )
                      : DefaultTextStyle(
                          style: const TextStyle(fontSize: 16),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            displayFullTextOnTap: true,
                            totalRepeatCount: 1,
                            onFinished: () => context
                                .read<ChatProvider>()
                                .setIsWriting(stillWriting: false),
                            animatedTexts: [TyperAnimatedText(message.trim())],
                          ),
                        ),
                ),
                !isBotMessage
                    ? const SizedBox.shrink()
                    : Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.thumb_up_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.thumb_down_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        )
      ],
    );
  }
}
