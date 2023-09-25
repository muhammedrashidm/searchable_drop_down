import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var errMsg = "";

class TextFieldWidget extends StatefulWidget {
  final TextInputType? textInputType;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final Color? bgColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? disabledColor;
  final Color? outlineColor;
  final int? maxLength;
  final EdgeInsetsGeometry? padding;
  final double? outlineWidth;
  final double? borderRadius;
  final String? defaultText;
  final double? hintSize;
  final List<TextInputFormatter>? inputFormatter;
  final double? textSize;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool? passwordVisibility;
  final TextAlign? textAlign;
  final bool? isReadOnly;
  final FontWeight? fontWeight;

  final dynamic controller;
  final String? Function(String?)? functionValidate;
  final String? parametersValidate;
  final TextInputAction actionKeyboard;
  final Function? onSubmitField;
  final Function? onFieldTap;
  final Function? onEditingEnd;
  final TextCapitalization? textCapitalization;
  final double? height;
  final int? maxlines;
  final BoxConstraints? suffixIconConstraints;

  final void Function(String)? doOnChanged;
  final bool isSuffix;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.height,
    this.focusNode,
    this.textInputType,
    this.defaultText,
    this.obscureText = false,
    this.controller,
    this.functionValidate,
    this.parametersValidate,
    this.actionKeyboard = TextInputAction.next,
    this.onSubmitField,
    this.onFieldTap,
    this.prefixIcon,
    this.bgColor,
    this.textColor,
    this.outlineColor,
    this.outlineWidth,
    this.borderRadius,
    this.hintColor,
    this.labelText,
    this.suffixIcon,
    this.isReadOnly,
    this.hintSize,
    this.textSize,
    this.textAlign,
    this.prefixText,
    this.maxLength,
    this.inputFormatter,
    this.textCapitalization,
    this.maxlines,
    this.padding,
    this.fontWeight,
    this.passwordVisibility,
    this.doOnChanged,
    this.onEditingEnd,
    this.suffixIconConstraints,
    this.disabledColor,
    this.isSuffix = false,
  });

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  double bottomPaddingToError = 14;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.white,
      ),
      child: TextFormField(
        maxLines: widget.maxlines,
        maxLength: widget.maxLength,
        cursorColor: Colors.grey.shade800,
        obscureText: _passwordVisible,
        keyboardType: widget.textInputType,
        inputFormatters: widget.textInputType == TextInputType.number
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : widget.inputFormatter,
        readOnly: widget.isReadOnly ?? false,
        focusNode: widget.focusNode,
        textAlign: widget.textAlign ?? TextAlign.start,
        style: TextStyle(
          fontSize: widget.textSize ?? 11,
          fontWeight: widget.fontWeight ?? FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 1,
        ),
        initialValue: widget.defaultText,
        // inputFormatters: widget.inputFormatter,
        decoration: InputDecoration(
          hintMaxLines: 1,
          counterText: "",
          prefixText: widget.prefixText,
          prefixIcon: widget.prefixIcon,
          suffixIconConstraints: widget.suffixIconConstraints,
          suffixIcon: widget.obscureText && widget.isSuffix
              ? Focus(
            descendantsAreFocusable: false,
            skipTraversal: true,
            child: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey.shade400,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          )
              : widget.suffixIcon,
          hintText: widget.labelText ?? widget.hintText,
          fillColor: widget.isReadOnly != null && widget.isReadOnly!
              ? widget.disabledColor ?? AppColors.primaryDisabled
              : widget.bgColor ?? AppColors.primaryLight,
          //........
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.isReadOnly != null && widget.isReadOnly!
                      ? widget.disabledColor ?? AppColors.primaryDisabled
                      : widget.outlineColor ?? AppColors.primaryLight),
              //....... change primary light temp to primary light for blue text field
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 2))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.isReadOnly != null && widget.isReadOnly!
                      ? widget.disabledColor ?? AppColors.primaryDisabled
                      : widget.outlineColor ?? AppColors.primaryLight),
              //..........
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 2))),
          hintStyle: TextStyle(
            color: widget.hintColor ?? AppColors.subTextBlack,
            fontSize: 11,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            letterSpacing: 1,
          ),
          contentPadding:
          widget.padding ?? EdgeInsets.symmetric(vertical: widget.height ?? 10, horizontal: 8),
          isDense: true,
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontSize: 9,
            height: 0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 0.8),
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 2.0))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 2.0))),
        ),
        textInputAction: widget.actionKeyboard,
        onChanged: widget.doOnChanged,
        controller: widget.controller,
        validator: widget.functionValidate,
        onFieldSubmitted: (value) {
          if (widget.onSubmitField != null) widget.onSubmitField!();
        },
        onTap: () {
          if (widget.onFieldTap != null) widget.onFieldTap!();
        },
        onEditingComplete: () {
          if (widget.onEditingEnd != null) widget.onEditingEnd!();
        },
      ),
    );
  }
}

