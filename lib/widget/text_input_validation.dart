import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wefinex/utils/uidata.dart';

typedef ValidateFunc = bool Function(String);
typedef GetTextCb = void Function(String);

class TextInputValidation extends StatefulWidget {
  final String hintText;

  final TextEditingController controller;

  final bool isInputValid;
  final bool isInputNumber;
  final bool isTransparent;
  final String validateErrMsg;

  TextInputValidation(
      {this.hintText = "",
      this.validateErrMsg,
      this.controller,
      this.isInputNumber = false,
      this.isInputValid = false,
      this.isTransparent = false});

  @override
  _TextInputValidationState createState() => _TextInputValidationState();
}

class _TextInputValidationState extends State<TextInputValidation> {
  @override
  Widget build(BuildContext context) {
    print('_TextInputValidationState=' +
        widget.validateErrMsg +
        'isInputValid==' +
        widget.isInputValid.toString());
    if (widget.isInputValid) {
      return _buildTextField();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTextField(),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            widget.validateErrMsg,
            style: TextStyle(
              color: MyColors.orangeRed,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return CupertinoTextField(
      controller: widget.controller,
      placeholder: widget.hintText,
      keyboardType: widget.isInputNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      placeholderStyle: TextStyle(
        color: MyColors.blueGrey,
        fontSize: 18.0,
      ),
      style: TextStyle(color: MyColors.black),
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 20.0,
      ),
      suffixMode: OverlayVisibilityMode.editing,
      decoration: BoxDecoration(
          color: widget.isTransparent
              ? MyColors.transparent
              : MyColors.veryLightPink,
          borderRadius: BorderRadius.circular(30.0)),
      cursorColor: MyColors.black,
    );
  }
}
