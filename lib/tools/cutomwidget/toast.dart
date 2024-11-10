import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomToastBar extends StatelessWidget {
  final String message;
  final IconData icon;
  final int durationMilliseconds;
  final bool autoDismiss;

  const CustomToastBar({
    Key? key,
    required this.message,
    this.icon = Icons.check,
    this.durationMilliseconds = 2000,
    this.autoDismiss = true,
  }) : super(key: key);

  void show(BuildContext context) {
    DelightToastBar(
      builder: (context) => ToastCard(
        leading: Icon(
          icon,
          size: 28,
        ),
        title: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      snackbarDuration: Duration(milliseconds: durationMilliseconds),
      position: DelightSnackbarPosition.top,
      autoDismiss: autoDismiss,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Placeholder; this widget only serves to trigger the toast.
  }
}
