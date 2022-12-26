import 'dart:ui';

import 'package:flutter/material.dart';

class RoundedRectangeButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final VoidCallback? callback;
  final double? padding;

  const RoundedRectangeButton({
    required this.text,
    this.padding,
    this.backgroundColor,
    this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        padding: EdgeInsets.all(padding ?? 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            18.0,
          ),
        ),
      ),
      onPressed: callback ?? () => {},
      child: Text(text),
    );
  }
}

class IconWithTextElevatedButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? callback;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const IconWithTextElevatedButton({
    required this.text,
    required this.icon,
    this.callback,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color bcolor =
        backgroundColor ?? Theme.of(context).colorScheme.secondary;
    final Color fcolor = foregroundColor ?? Colors.white;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: bcolor,
        foregroundColor: fcolor,
      ),
      onPressed: callback ?? () => {},
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: fcolor,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Center(
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}
