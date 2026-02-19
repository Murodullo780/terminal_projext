import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final String? subtext;
  final Widget? child;
  final Widget? onWidget;
  final double textFontSize;
  final FontWeight textFontWeight;
  final Color? color;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool textToUpperCase;
  final String? preText;
  final Widget? preIcon;
  final double? height;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Color borderSideColor;
  final double borderSideWidth;
  final bool showOnlyBottomBorderRadius;
  final bool? showArrow;
  final double? bottomLeftRadius;
  final bool? useExpandedOnText;
  final bool useRounding;
  final bool connectionRequired;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.subtext,
    this.child,
    required this.onPressed,
    this.textFontSize = 14,
    this.textFontWeight = FontWeight.normal,
    this.color,
    this.textColor = Colors.white,
    this.textToUpperCase = false,
    this.preText,
    this.preIcon,
    this.height,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.borderRadius = 0.0,
    this.borderSideColor = Colors.transparent,
    this.borderSideWidth = 1.0,
    this.showOnlyBottomBorderRadius = false,
    this.showArrow = true,
    this.bottomLeftRadius = 0,
    this.useExpandedOnText,
    this.useRounding = false,
    this.onWidget,
    this.connectionRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (useRounding && height == null) ? 50 : height,
      padding: padding,
      margin: margin ?? (useRounding ? EdgeInsets.all(16) : null),
      child: ElevatedButton(
        onPressed: () async {
          onPressed?.call();
          // if (connectionRequired) {
          //   if (await DioSingleton.checkConnection(showError: connectionRequired) == false) {
          //     return;
          //   }
          // }
          // if (!isButtonDisabled) {
          //   isButtonDisabled = true;
          //   Future.delayed(const Duration(milliseconds: 200), onPressed);
          //   Future.delayed(const Duration(seconds: 1), () {
          //     isButtonDisabled = false;
          //   });
          // }
        },
        style: ButtonStyle(
          side: WidgetStateProperty.all(BorderSide(width: borderSideWidth, color: borderSideColor)),
          backgroundColor: WidgetStateProperty.all(color ?? Theme.of(context).primaryColor),
          overlayColor: WidgetStateProperty.all(Colors.black12),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: useRounding
                  ? BorderRadius.circular(100)
                  : showOnlyBottomBorderRadius
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(bottomLeftRadius ?? 0),
                          bottomRight: Radius.circular(borderRadius))
                      : BorderRadius.circular(borderRadius),
              side: BorderSide(color: borderSideColor),
            ),
          ),
        ),
        child: onWidget ??
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment:
                      subtext == null ? MainAxisAlignment.center : MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    if (preText != null)
                      Row(
                        children: [
                          Text(
                            preText ?? '',
                            style: TextStyle(
                              fontSize: textFontSize,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Text(
                              '|',
                              style: TextStyle(
                                  fontSize: (16),
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    if (preIcon != null)
                      Padding(padding: const EdgeInsets.only(right: 10.0), child: preIcon!),
                    if (useExpandedOnText == true)
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: Center(
                            child: Text(
                              textToUpperCase ? text.toUpperCase() : text,
                              style: TextStyle(
                                  fontSize: textFontSize,
                                  color: textColor,
                                  fontWeight: textFontWeight),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    else
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          textToUpperCase ? text.toUpperCase() : text,
                          style: TextStyle(
                              fontSize: textFontSize, color: textColor, fontWeight: textFontWeight),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (subtext != null) const Spacer(flex: 4),
                    if (subtext != null)
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(subtext ?? '',
                              style: TextStyle(
                                  fontSize: textFontSize,
                                  color: textColor,
                                  fontWeight: FontWeight.bold))),
                    // if (preText != null && preText != "0" && showArrow!)
                    // if (false)
                    //   Align(
                    //     alignment: Alignment.centerRight,
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 15, bottom: 3, right: 16),
                    //       child: SvgPicture.asset(
                    //         'assets/svg/arrow_right.svg',
                    //         color: Colors.white,
                    //         width: 17,
                    //         height: 17,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
                if (child != null) Container(child: child)
              ],
            ),
      ),
    );
  }
}
