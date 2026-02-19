import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  static InputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: Colors.transparent),
  );
  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF7F5F0),
    border: inputBorder,
    enabledBorder: inputBorder,
    focusedBorder: inputBorder,
    errorBorder: inputBorder,
    disabledBorder: inputBorder,
    hintStyle: const TextStyle(
      fontSize: 14,
    ),
    labelStyle: const TextStyle(
      fontSize: 14,
    ),
  );

  CustomTextField({
    super.key,
    this.height,
    this.label,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.autoFocus,
    this.controller,
    this.readOnly = false,
    this.focusNode,
    this.suffixIcon,
    this.enabled,
    this.onTap,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.borderRadius,
    this.filled,
    this.textCapitalization,
    this.inputFormatters,
    this.textAlign,
    this.onTapKeyboard,
  });

  final double? height;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? autoFocus;
  final TextEditingController? controller;
  final bool readOnly;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final bool? enabled;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSubmitted;
  final double? borderRadius;
  final bool? filled;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final void Function(bool opening)? onTapKeyboard;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _inputBorder = (inputBorder as OutlineInputBorder).copyWith(
      borderRadius: BorderRadius.circular(borderRadius ?? 6),
      borderSide: BorderSide(
        color: filled == false ? Color(0xffE5E5E5) : Colors.transparent,
        width: 1,
      ),
    );
    return SizedBox(
      height: height ?? 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            focusNode: focusNode,
            controller: controller,
            readOnly: readOnly,
            textAlign: textAlign ?? TextAlign.start,
            style: const TextStyle(fontSize: 14),
            obscureText: obscureText ?? false,
            autofocus: autoFocus ?? false,
            enabled: enabled,
            keyboardType: keyboardType ?? TextInputType.text,
            onTap: () {
              if (!readOnly) {
                _focusNode.requestFocus();
                SystemChannels.textInput.invokeMethod('TextInput.show');
              }
              if (onTap != null) onTap!();
            },
            validator: validator,
            onChanged: onChanged,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            inputFormatters: inputFormatters,
            decoration: inputDecoration.copyWith(
              filled: filled ?? true,
              isDense: true,
              labelText: label,
              suffixIcon: suffixIcon,
              hintText: hintText,
              border: _inputBorder,
              enabledBorder: _inputBorder,
              focusedBorder: _inputBorder,
              errorBorder: _inputBorder,
              hintStyle: const TextStyle(
                fontSize: 14,
              ),
              labelStyle: const TextStyle(
                fontSize: 14,
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
              ),
            ),
            onFieldSubmitted: (string) {
              if (onSubmitted != null) {
                onSubmitted!(string);
              }
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
