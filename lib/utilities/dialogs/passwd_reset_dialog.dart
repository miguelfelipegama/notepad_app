import 'package:flutter/cupertino.dart';
import 'package:notepad_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswdResetDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'Password reset e-mail sent please check inbox.',
    optionsBuilder: () => {'OK': null},
  );
}
