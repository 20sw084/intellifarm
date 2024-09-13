import 'package:flutter/material.dart';

class ConfirmDeleteCropDialog extends StatelessWidget {
  final Function onConfirm;

  const ConfirmDeleteCropDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deleting Crop!'),
      content: const Text(
          'All records associated with this crop will be deleted such as plantings, harvests, and treatments. \n Are you Sure?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.amber),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            // Call the onConfirm function passed from outside
            onConfirm();
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
          ),
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
