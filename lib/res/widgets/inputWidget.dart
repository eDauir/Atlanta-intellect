import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  final String? suffixIconPath;
  final String? prefixIconPath;
  final bool? autocorrect;
  final AutovalidateMode? AutovalidateModeSetting;
  final bool inputFormatters;
  final int maxLines;
  final double? borderRadius;

  const InputWidget(
      {this.controller,
      this.isPasswordField,
      this.fieldKey,
      this.hintText,
      this.inputFormatters = false,
      this.autocorrect,
      this.maxLines = 1,
      this.borderRadius,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.onFieldSubmitted,
      this.inputType,
      this.prefixIconPath,
      this.AutovalidateModeSetting,
      this.suffixIconPath});

  @override
  _InputWidgetState createState() => new _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late FocusNode focusNode;

  bool _obscureText = true;

  bool isError = false;

  String? errorVal;

  var maskFormatter = new MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });

    if (widget.controller != null) {
      widget.controller!.addListener(() {
        errorVal = widget.validator!(widget.controller!.text);
        if (errorVal != null && isError == false) {
          setState(() {
            isError = true;
          });
        } else if (isError == true && errorVal == null) {
          setState(() {
            isError = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    if (widget.controller != null) {
      widget.controller!.dispose();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    double valueBorderRadius = widget.borderRadius ?? 50;

    return Column(
      children: [
        Container(
          // height: marginScale(isError ? 70 : 56),
          width: double.infinity,
          decoration: BoxDecoration(
              // color: primary_color.withOpacity(.35),
              borderRadius:
                  BorderRadius.circular(marginScaleWC(valueBorderRadius)),
              boxShadow:
                  isError == false && !focusNode.hasFocus ? [shadow] : null),
          child: TextFormField(
            inputFormatters: widget.inputFormatters ? [maskFormatter] : null,
            autovalidateMode: widget.AutovalidateModeSetting,
            focusNode: focusNode,
            autocorrect: widget.autocorrect ?? true,
            style: TextStyle(color: Colors.black),
            controller: widget.controller,
            maxLines: widget.maxLines,
            keyboardType: widget.inputType,
            key: widget.fieldKey,
            obscureText: widget.isPasswordField == true ? _obscureText : false,
            onSaved: widget.onSaved,
            validator: widget.validator,
            onFieldSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 14, bottom: 14)
                  .copyWith(left: widget.prefixIconPath == null ? 15 : 0),
              fillColor: isError && !focusNode.hasFocus
                  ? redColor.withOpacity(0.1)
                  : focusNode.hasFocus
                      ? primary_color.withOpacity(0.1)
                      : Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: isError ? 1 : 0,
                      style: isError ? BorderStyle.solid : BorderStyle.none,
                      color: isError ? redColor : Colors.transparent),
                  borderRadius:
                      BorderRadius.circular(marginScaleWC(valueBorderRadius))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: primary_color),
                  borderRadius:
                      BorderRadius.circular(marginScaleWC(valueBorderRadius))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  borderRadius:
                      BorderRadius.circular(marginScaleWC(valueBorderRadius))),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: redColor),
                  borderRadius:
                      BorderRadius.circular(marginScaleWC(valueBorderRadius))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: redColor),
                  borderRadius:
                      BorderRadius.circular(marginScaleWC(valueBorderRadius))),
              filled: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 14, color: greyColor),
              prefixIcon: widget.prefixIconPath != null
                  ? Padding(
                      padding: EdgeInsets.all(marginScaleWC(15))
                          .copyWith(right: marginScaleWC(13)),
                      child: Container(
                        width: marginScaleWC(15),
                        height: marginScaleWC(15),
                        child: SvgPicture.asset(
                          widget.prefixIconPath.toString(),
                          width: marginScaleWC(15),
                          height: marginScaleWC(15),
                          color: isError && !focusNode.hasFocus
                              ? redColor
                              : focusNode.hasFocus
                                  ? primary_color
                                  : null,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : null,
              suffixIcon: widget.suffixIconPath != null
                  ? Padding(
                      padding: EdgeInsets.all(marginScaleWC(15))
                          .copyWith(left: marginScaleWC(13)),
                      child: Container(
                        width: marginScaleWC(15),
                        height: marginScaleWC(15),
                        child: SvgPicture.asset(
                          widget.suffixIconPath.toString(),
                          width: marginScaleWC(15),
                          height: marginScaleWC(15),
                          color: isError && !focusNode.hasFocus
                              ? redColor
                              : focusNode.hasFocus
                                  ? primary_color
                                  : null,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: widget.isPasswordField == true
                          ? Padding(
                              padding: EdgeInsets.all(marginScaleWC(5))
                                  .copyWith(
                                      left: marginScaleWC(13),
                                      right: marginScaleWC(10)),
                              child: Container(
                                width: marginScaleWC(16),
                                height: marginScaleWC(16),
                                child: SvgPicture.asset(
                                  'assets/img/eye.svg',
                                  width: marginScaleWC(16),
                                  height: marginScaleWC(16),
                                  fit: BoxFit.contain,
                                  color: isError && !focusNode.hasFocus
                                      ? redColor
                                      : greyColor,
                                ),
                              ),
                            )
                          : Text(""),
                    ),
            ),
          ),
        ),
        // if (errorVal != null)
        //   Align(
        //     alignment: Alignment.centerLeft,
        //     child: Text(
        //       errorVal!,
        //       style: Theme.of(context)
        //           .textTheme
        //           .headline6!
        //           .copyWith(color: Colors.red),
        //     ),
        //   )
      ],
    );
  }
}
