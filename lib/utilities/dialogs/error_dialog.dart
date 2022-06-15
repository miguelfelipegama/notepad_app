import 'package:flutter/widgets.dart';
import 'package:notepad_app/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'Error',
    content: text,
    optionsBuilder: () => {'OK': null},
  );
}
