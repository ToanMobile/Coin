import 'package:flutter/material.dart';
import 'package:wefinex/widget/text_input_validation.dart';

class FormVoucher extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormVoucher> {
  bool isNameInputValid, isSdtInputValid;
  String nameInputValidateErr, sdtInputValidateErr;

  TextEditingController nameController = new TextEditingController(),
      sdtController = new TextEditingController(),
      tkController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    isNameInputValid = true; // init form
    isSdtInputValid = true; // init form
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextInputValidation(
          controller: nameController,
          hintText: "Họ và tên",
          validateErrMsg: getEmailValidateErrMsg(),
          isInputValid: isNameInputValid,
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextInputValidation(
          controller: sdtController,
          hintText: "Số điện thoại đăng ký",
          validateErrMsg: getPwdValidateErrMsg(),
          isInputValid: isSdtInputValid,
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextInputValidation(
          controller: tkController,
          hintText: "Tên tài khoản KU",
          validateErrMsg: getPwdValidateErrMsg(),
          isInputValid: isNameInputValid,
        ),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  bool notBlank(String input) {
    return input.length != 0;
  }

  void validateForm() {
    isNameInputValid = notBlank(nameController.text);
    isSdtInputValid = notBlank(tkController.text);

    if (isNameInputValid && isSdtInputValid) {
      // TODO: Call API here
    } else {
      setState(() {});
    }
  }

  String getEmailValidateErrMsg() {
    // TODO: using switch case to get another validate message type
    if (!isNameInputValid) {
      return "This field can not blank!";
    }
    return null;
  }

  String getPwdValidateErrMsg() {
    if (!isSdtInputValid) {
      return "This field can not blank!";
    }
    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    sdtController.dispose();
    tkController.dispose();
    super.dispose();
  }
}
