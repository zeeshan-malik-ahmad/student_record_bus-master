// Flutter imports:
import 'package:flutter/material.dart';
import 'package:student_record_bus/chat_bot/chat_message.dart';

import 'api_controller.dart';
import 'app_constants.dart';
import 'chat_api_response.dart';

// Project imports:

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  final apiController = ApiController();

  @override
  void initState() {
    welcome();
    super.initState();
  }

  void welcome() async {
    var response = await apiController.getData('');
    logger.i(response);
    ChatMessage message = ChatMessage(
      text: ChatApiResponse.fromJson(response).response,
      name: "Atom",
      type: false,
    );

    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void response(query) async {
    _textController.clear();
    var response = await apiController.getData(query);

    ChatMessage message = ChatMessage(
      text: ChatApiResponse.fromJson(response).response,
      name: "Atom",
      type: false,
    );

    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    if (_textController.text.trim().isNotEmpty) {
      _textController.clear();
      ChatMessage message = ChatMessage(
        text: text,
        name: 'User',
        type: true,
      );
      setState(() {
        _messages.insert(0, message);
      });
      response(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Atom 🤖"),
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        const Divider(height: 1.0),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}
