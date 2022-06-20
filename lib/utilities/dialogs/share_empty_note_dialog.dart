import 'package:flutter/widgets.dart';
import 'package:notepad_app/utilities/dialogs/generic_dialog.dart';

Future<void> showShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'Cannot share empty notes',
    optionsBuilder: () => {'OK': null},
  );
}
