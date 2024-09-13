import 'package:flutter/material.dart';

class ConfirmDeleteTransactionDialog extends StatelessWidget {
  final Function onConfirm;

  ConfirmDeleteTransactionDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Deleting Income!'),
      content: Text('All records associated with it will be deleted. \n Are you Sure?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
          ),
          child: Text('Cancel', style: TextStyle(color: Colors.white),),
        ),
        TextButton(
          onPressed: () {
            // Call the onConfirm function passed from outside
            onConfirm();
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
