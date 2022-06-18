import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart';
import 'package:flutter_native_text_input_example/demo_item.dart';
import 'package:flutter_native_text_input_example/more_use_case_listing_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  _onChangeText(value) => debugPrint("_onChangeText: $value");

  _onSubmittedText(value) => debugPrint("_onSubmittedText: $value");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Page'),
      ),
      body: Column(
        children: [
          Expanded(child: Center(child: Text("Body"))),
          DemoItem(
            title: "Multiline Text Input",
            child: NativeTextInput(
              minHeightPadding: 14,
              minLines: 1,
              maxLines: 6,
              keyboardType: KeyboardType.defaultType,
              returnKeyType: ReturnKeyType.defaultAction,
              iosOptions: IosOptions(
                keyboardAppearance: Brightness.light,
              ),
              placeholder: "S().message",
              textCapitalization: TextCapitalization.sentences,
              onChanged: (val) {
                print("onChanged => $val");
              },
              onTap: () {
                print("onTap");
              },
            ),
          ),
        ],
      ),
    );
  }
}
