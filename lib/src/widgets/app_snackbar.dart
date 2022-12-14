import 'package:flutter/material.dart';

Function appMessage(BuildContext context) {
  return (String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  };
}

Function appError(BuildContext context, {bool autoClose = false}) {
  return (
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration:
          autoClose ? const Duration(seconds: 5) : const Duration(days: 365),
      action: SnackBarAction(
        label: "CLOSE",
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
      content: Row(
        children: [
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
            ),
          )
        ],
      ),
    ));
  };
}

Future<bool?> appConfirm(
    BuildContext context, String title, String message) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
