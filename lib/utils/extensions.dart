import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interviewquestion/resource/colors.dart';
import 'package:interviewquestion/resource/font.dart';
import 'package:interviewquestion/resource/style.dart';
import 'package:interviewquestion/resource/validation.dart';
import 'package:interviewquestion/resource/value.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'state_status.dart';

extension DynamicUtil on dynamic {
  bool get isNull => GetUtils.isNull(this);

  bool get isNullOrBlank => GetUtils.isNullOrBlank(this);

  void printError(
          {String info = '', Function logFunction = GetUtils.printFunction}) =>
      logFunction('Error: ${this.runtimeType}', this, info, isError: true);

  void printInfo(
          {String info = '',
          Function printFunction = GetUtils.printFunction}) =>
      printFunction('Info: ${this.runtimeType}', this, info);

  void toast(
      {String title = appName,
      message,
      Color backgroundColor = toastBackgroundColor,
      Color textColor = toastMessageColor,
      SnackPosition flushBarPosition = SnackPosition.BOTTOM}) {
    Get.showSnackbar(GetBar(
        animationDuration: Duration(seconds: 2),
        message: '',
        title: '',
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.black.withOpacity(0.2),
        duration: Duration(milliseconds: 2000),
        overlayColor: Colors.black,
        overlayBlur: 0,
        backgroundGradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.deepOrange.withOpacity(0.8),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 2.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        barBlur: 6,
        titleText: Text(title, style: flushBarTitleStyle(toastTitleColor)),
        messageText: Text(message, style: flushBarMessageStyle(textColor))));
  }
}

extension ContextExtensions on BuildContext {
  double widthInPercent(double percent) {
    var toDouble = percent / 100;
    return MediaQuery.of(this).size.width * toDouble;
  }

  double heightInPercent(double percent) {
    var toDouble = percent / 100;
    return MediaQuery.of(this).size.height * toDouble;
  }

  showProgress() {
    showDialog(
        context: this,
        barrierDismissible: false,
        builder: (context) => Container(
            alignment: FractionalOffset.center,
            child: CircularProgressIndicator(strokeWidth: 1)));
  }

  void hideProgress() {
    Navigator.pop(this);
  }
}

extension DateTimeExtensions on int {
  dateTimeyyyyMMddhhmma() {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(this);
    return DateFormat("yyyy-MM-dd hh:mm a").format(dateTime);
  }
}

extension ValiationExtensions on String {
  mobileCalling() => launch('tel:' + this);

  pastOrderColor() {
    switch (this) {
      case 'completed':
        return pastOrderSettledColor;
        break;

      case 'rejected':
        return pastOrderRejectedColor;
        break;

      case 'canceled':
        return pastOrderRejectedColor;
        break;
    }
  }

  validateEmail() {
    var regExp = RegExp(emailPattern);
    if (this.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(this)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  validatePassword() {
    if (this.isEmpty) {
      return 'Password is required';
    } else if (this.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  validateMobile() {
    var regExp = RegExp(mobilePattern);
    if (this.replaceAll(" ", "").isEmpty) {
      return 'Mobile is required';
    } else if (this.replaceAll(" ", "").length != 10) {
      return 'Mobile number must 10 digits';
    } else if (!regExp.hasMatch(this.replaceAll(" ", ""))) {
      return 'Mobile number must be digits';
    }
    return null;
  }

  String validUserName() {
    var regExp = RegExp(userNamePattern);
    if (this.isEmpty) {
      return 'Name is required';
    } else if (!regExp.hasMatch(this)) {
      return 'Name must be a-z and A-Z';
    }
    return null;
  }

  String validateAddress() {
    var regExp = RegExp(addressPattern);
    if (this.isEmpty) {
      return 'Address is required';
    } else if (!regExp.hasMatch(this)) {
      return 'Address must be text and numeric';
    }
    return null;
  }

  String validatePinCode() {
    if (this.isEmpty) {
      return 'Pin code is required';
    } else if (this.length < 6) {
      return 'Pin code must be 6 characters';
    }
    return null;
  }

  String validateCurrentPassword() {
    if (this.isEmpty) {
      return 'Current password required';
    } else if (this.length < 6) {
      return 'Current password must be at least 6 characters';
    }
    return null;
  }

  String validateNewPassword() {
    if (this.isEmpty) {
      return 'New password required';
    } else if (this.length < 6) {
      return 'New password must be at least 6 characters';
    }
    return null;
  }

  bool validationEqual(String currentValue, String checkValue) {
    if (currentValue == checkValue) {
      return true;
    } else {
      return false;
    }
  }
}

extension WidgetExtensions on Widget {
  circleProgressIndicator() => Container(
      alignment: FractionalOffset.center,
      child: CircularProgressIndicator(strokeWidth: 1));

  emptyWidget({String message = dataNotMessage}) =>
      Center(child: Text(message, style: dataNotAvailableStyle));

  listView(
          {StateStatus stateStatus,
          String dataNotFoundMessage,
          bool shrinkWrap = false,
          int length,
          Function(BuildContext context, int index) itemBuilder}) =>
      stateStatus == StateStatus.LOADING
          ? circleProgressIndicator()
          : length == 0
              ? Stack(children: <Widget>[
                  emptyWidget(message: dataNotFoundMessage),
                  ListView()
                ])
              : listViewBuilder(
                  length: length,
                  shrinkWrap: shrinkWrap,
                  itemBuilder: itemBuilder);

  listViewBuilder(
          {int length,
          bool shrinkWrap = false,
          Function(BuildContext context, int index) itemBuilder}) =>
      ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          //addAutomaticKeepAlives: true,
          shrinkWrap: shrinkWrap,
          itemCount: length,
          itemBuilder: itemBuilder);

  emptySearchWidget() =>
      Text(noSearchResultMessage, style: searchDataNotAvailableStyle);

  inputField(TextEditingController textEditingController,
          {ValueChanged<String> onChanged,
          int maxLength,
          TextInputType keyboardType,
          String hintText,
          String labelText,
          int maxLines = 1,
          bool obscureText = false,
          InkWell inkWell,
          FormFieldValidator<String> validation}) =>
      TextFormField(
          controller: textEditingController,
          cursorColor: appBarTitleColor,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: TextStyle(fontFamily: regularFont),
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
              focusedErrorBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 1.0)),
              errorBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 1.0)),
              errorStyle: TextStyle(fontFamily: regularFont, color: Colors.red),
              labelStyle:
                  TextStyle(fontFamily: regularFont, color: Colors.black),
              suffixStyle:
                  TextStyle(fontFamily: regularFont, color: Colors.black),
              prefixStyle:
                  TextStyle(fontFamily: regularFont, color: Colors.black),
              counterStyle:
                  TextStyle(fontFamily: regularFont, color: Colors.black),
              helperStyle:
                  TextStyle(fontFamily: regularFont, color: Colors.black),
              hintText: hintText,
              counterText: '',
              labelText: labelText,
              suffix: inkWell),
          validator: validation);

  size({double widthScale = 0.0, double heightScale = 0.0}) =>
      SizedBox(width: widthScale, height: heightScale);

  socialIcon({Icon icon, backgroundColor: Colors, VoidCallback voidCallback}) =>
      Container(
          width: 40.0,
          height: 40.0,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
          child: RawMaterialButton(
              shape: CircleBorder(), onPressed: voidCallback, child: icon));

  roundCircleButton(
          {IconData iconData,
          Color color,
          bool isMini: true,
          VoidCallback voidCallback}) =>
      FloatingActionButton(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          mini: isMini,
          onPressed: voidCallback,
          child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientsButton)),
              child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[Icon(iconData, size: 30, color: color)])));

  customFloatForm(
          {IconData icon,
          Color color,
          VoidCallback qrCallback,
          bool isMini = false,
          StateStatus stateStatus}) =>
      FloatingActionButton(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          mini: isMini,
          onPressed: stateStatus != StateStatus.LOADING ? qrCallback : null,
          child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientsButton)),
              child: Stack(fit: StackFit.expand, children: <Widget>[
                stateStatus == StateStatus.LOADING
                    ? CircularProgressIndicator(strokeWidth: 1)
                    : Offstage(),
                Icon(icon, size: 30, color: color)
              ])));
}
