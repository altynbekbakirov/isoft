import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../l10n/language_constants.dart';

Future<bool> onWillPop(BuildContext context, DateTime timeBackPressed) async {
  final difference = DateTime.now().difference(timeBackPressed);
  final isExitWarning = difference >= Duration(seconds: 2);

  timeBackPressed = DateTime.now();

  if (isExitWarning) {
    Fluttertoast.showToast(
        msg: translation(context).press_back_again_to_exit, fontSize: 14);
    return false;
  } else {
    Fluttertoast.cancel();
    return true;
  }
}
