import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:isolate_tests/ball_animation.dart';

String _name = 'Main';

class NextWidget extends StatelessWidget {
  const NextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FriendlyChat',
      home: ChatScreen(),
    );
  }
}

class TypingAlert extends StatelessWidget {
  TypingAlert({required Animation<double> animationController, Key? key})
      : color = ColorTween(begin: Colors.black, end: Colors.black26).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        offsetY = Tween<double>(begin: -0, end: -10).animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInSine)),
        offsetText = Tween<double>(begin: 0, end: -10).animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInSine)),
        super(key: key);

  final Animation<Color?> color;
  final Animation<double> offsetY;
  final Animation<double> offsetText;

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.1;
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              child: Text(_name[0]),
              radius: 20,
            ),
          ],
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          'Is Typing...',
          style: TextStyle(color: Colors.grey.withOpacity(0.7)),
        ),
        const BallsIsTyping(),
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.isSent,
    required this.text,
    required this.animationController,
    Key? key,
  }) : super(key: key);
  final String text;
  final AnimationController animationController;
  final bool isSent;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.linearToEaseOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: isSent
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(child: Text(_name[0])),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name,
                            style: Theme.of(context).textTheme.bodyText1),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(text),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name,
                            style: Theme.of(context).textTheme.bodyText1),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(text),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: CircleAvatar(child: Text(_name[0])),
                  ),
                ],
              ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool testBool = false;
  bool isTyping = false;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    var message = ChatMessage(
      isSent: testBool,
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
      testBool = !testBool;
    });
    isTyping = false;
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  Future playAnimation() async {
    if (!animationController.isAnimating) {
      await animationController.forward();
      await animationController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FriendlyChat')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          isTyping
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return TypingAlert(
                        animationController: animationController.view,
                      );
                    },
                  ),
                )
              : const SizedBox(),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      isTyping = true;
                      playAnimation();
                    } else {
                      isTyping = false;
                      animationController.reset();
                    }
                  });
                },
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

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    animationController.dispose();
    super.dispose();
  }
}
