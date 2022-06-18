import 'package:flutter/material.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart';
import 'package:flutter_native_text_input_example/demo_item.dart';

class MoreUseCaseListingPage extends StatefulWidget {
  const MoreUseCaseListingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoreUseCaseListingPageState();
}

class _MoreUseCaseListingPageState extends State<MoreUseCaseListingPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _changeTextController = TextEditingController();

  String _currentTextInput = '';

  _onChangeText(value) => debugPrint("_onChangeText: $value");

  _onSubmittedText(value) => debugPrint("_onSubmittedText: $value");

  _onTap(BuildContext context) {
    const snackBar = SnackBar(content: Text('Tapped!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More Use Cases"),
      ),
      body: DemoItem(
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
            textCapitalization:
            TextCapitalization.sentences,
            onChanged: (val) {
              print("onChanged => $val");
            },
            onTap: () {
              print("onTap");
            },
          )),
    );
  }
}
