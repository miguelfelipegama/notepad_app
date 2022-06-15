import 'package:flutter/widgets.dart';
import 'package:notepad_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete Note',
    content: 'Are you sure?',
    optionsBuilder: () => {'No': false, 'Yes': true},
  ).then(
    (value) => value ?? false,
  );
}
