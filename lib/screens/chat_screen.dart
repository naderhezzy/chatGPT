import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:ai_bot/providers/chat_provider.dart';
import 'package:ai_bot/providers/model_provider.dart';
import 'package:ai_bot/services/services.dart';
import 'package:ai_bot/services/assets_manager.dart';
import 'package:ai_bot/constants/constants.dart';
import 'package:ai_bot/widgets/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false;

  late FocusNode _focusNode;
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
  }

  void _sendMessage({
    required String prompt,
    required String model,
    required BuildContext context,
  }) async {
    if (prompt.isEmpty) {
      return;
    }
    _focusNode.unfocus();
    _textEditingController.clear();
    setState(() => _isLoading = true);
    _scrollToEnd();

    try {
      await context
          .read<ChatProvider>()
          .sendMessage(prompt: prompt, model: model);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Server Error',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Show error',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                backgroundColor: Colors.redAccent,
              ),
            ),
          ),
        ),
      );
    } finally {
      _scrollToEnd();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _scrollToEnd() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = context.read<ChatProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: FittedBox(
          child: Text(context.watch<ModelsProvider>().currentModel),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await Services.showModalSheet(context: context);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Server Error',
                      style: TextStyle(fontSize: 18),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: chatProvider.chatList.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return MessageWidget(
                    message: chatProvider.chatList[index].body,
                    isBotMessage: chatProvider.chatList[index].isBotMessage,
                  );
                },
              ),
            ),
            if (_isLoading)
              const SpinKitThreeBounce(color: Colors.white, size: 18),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: const Offset(0, 7), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(top: 8),
              child: Consumer<ChatProvider>(
                builder: (_, chatProvider, __) {
                  return Row(
                    children: [
                      if (!_isLoading && !chatProvider.isWriting)
                        Expanded(
                          child: TextField(
                            focusNode: _focusNode,
                            controller: _textEditingController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration.collapsed(
                              hintText: "How can i help you!",
                              hintStyle: TextStyle(color: Colors.white38),
                            ),
                            onSubmitted: (value) => _sendMessage(
                              prompt: value,
                              model:
                                  context.read<ModelsProvider>().currentModel,
                              context: context,
                            ),
                          ),
                        ),
                      if (!_isLoading && !chatProvider.isWriting)
                        IconButton(
                          onPressed: () => _sendMessage(
                            prompt: _textEditingController.text,
                            model: context.read<ModelsProvider>().currentModel,
                            context: context,
                          ),
                          icon: const Icon(
                            Icons.send,
                            color: Colors.greenAccent,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
