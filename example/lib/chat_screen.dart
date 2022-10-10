import 'package:flutter/material.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _focusNode = FocusNode();

  late final _messageNotifier = ValueNotifier(_messageController.text.isEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat screen'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(
                bottom: 6.0,
                top: 6.0,
                left: 15.0,
                right: 15.0,
              ),
              constraints: const BoxConstraints(
                minHeight: 36,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 0.5,
                          color: const Color(0xffCFCFCF),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF007AEA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 9.0),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left:0, right:8),
                              child: Center(
                                child: NativeTextInput(
                                  style: TextStyle(
                                    letterSpacing: '-15@17'.va,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  minHeightPadding: 12,
                                  controller: _messageController,
                                  focusNode: _focusNode,
                                  minLines: 1,
                                  maxLines: 5,
                                  keyboardType: KeyboardType.defaultType,
                                  returnKeyType: ReturnKeyType.defaultAction,
                                  iosOptions: IosOptions(
                                    keyboardAppearance: Brightness.light,
                                    placeholderStyle: TextStyle(
                                      letterSpacing: '-15@17'.va,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  placeholder: 'Message',
                                  textCapitalization: TextCapitalization.sentences,
                                  onChanged: (val) {
                                    final isEmpty = val.trim().isEmpty;
                                    _messageNotifier.value = isEmpty;
                                    // message controller text is not fixed. Added this print.
                                    print("message controller text"+_messageController.text);
                                    //this is your print which is not good for testing _messageController fix
                                    print("onChanged=:: $val :: ${_messageController.text}");
                                  },
                                  onTap: () {
                                    print("onTap");
                                  },
                                ),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _messageNotifier,
                            builder: (ctx, value, child) {
                              if (value) {
                                return const Padding(
                                  padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                                  child: Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: Color(0xFF9E9E9E),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AEA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension StringUtils on String {
  double get va {
    final values = split('@');
    final num psValue =
        int.tryParse(values.first) ?? double.tryParse(values.first) ?? 0;
    final num fontSize =
        int.tryParse(values.last) ?? double.tryParse(values.last) ?? 0;
    return psValue * fontSize / 1000;
  }
}
