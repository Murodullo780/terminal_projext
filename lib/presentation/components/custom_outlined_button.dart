import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final Widget child;
  final Color sideColor;
  final EdgeInsets? padding;

  const CustomOutlinedButton({
    super.key,
    this.onPressed,
    required this.child,
    this.sideColor = const Color(0xffE5E5E5),
    this.onLongPress,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10000),
        side: BorderSide(color: sideColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10000),
        overlayColor: WidgetStateProperty.all(Colors.black12),
        onTap: onPressed,
        onLongPress: onLongPress,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8),
          child: Center(child: child),
        ),
      ),
    );
  }
}
