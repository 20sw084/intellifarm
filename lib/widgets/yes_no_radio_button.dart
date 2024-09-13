import 'package:flutter/material.dart';

class YesNoRadioButtonController {
  String? _selectedOption;
  final ValueNotifier<String?> notifier = ValueNotifier(null);

  String? get selectedOption => _selectedOption;

  set selectedOption(String? value) {
    _selectedOption = value;
    notifier.value = value;
  }
}

class YesNoRadioButton extends StatefulWidget {
  final YesNoRadioButtonController controller;

  const YesNoRadioButton({super.key, required this.controller});

  @override
  State<YesNoRadioButton> createState() => _YesNoRadioButtonState();
}

class _YesNoRadioButtonState extends State<YesNoRadioButton> {
  @override
  void initState() {
    super.initState();
    widget.controller.notifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: 'Yes',
          groupValue: widget.controller.selectedOption,
          onChanged: (value) {
            setState(() {
              widget.controller.selectedOption = value;
            });
          },
        ),
        const Text('Yes'),
        Radio<String>(
          value: 'No',
          groupValue: widget.controller.selectedOption,
          onChanged: (value) {
            setState(() {
              widget.controller.selectedOption = value;
            });
          },
        ),
        const Text('No'),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.notifier.removeListener(() {});
    super.dispose();
  }
}
