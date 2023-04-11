import 'dart:io';

import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/providers/auth.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:academy_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class EditPasswordScreen extends StatefulWidget {
  static const routeName = '/edit-password';
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool hidePassword = true;
  var _isLoading = false;
  final Map<String, String> _passwordData = {
    'oldPassword': '',
    'newPassword': '',
  };
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).updateUserPassword(
          _passwordData['oldPassword'].toString(),
          _passwordData['newPassword'].toString());

      CommonFunctions.showSuccessToast('Password updated Successfully');
    } on HttpException {
      var errorMsg = 'Password Update failed';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      // print(error);
      const errorMsg = 'Password Update failed!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: kDefaultInputBorder,
      focusedBorder: kDefaultFocusInputBorder,
      focusedErrorBorder: kDefaultFocusErrorBorder,
      errorBorder: kDefaultFocusErrorBorder,
      filled: true,
      hintStyle: const TextStyle(color: kFormInputColor),
      hintText: hintext,
      fillColor: Colors.white70,
      prefixIcon: Icon(
        iconData,
        color: kFormInputColor,
      ),
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            hidePassword = !hidePassword;
          });
        },
        color: kTextLowBlackColor,
        icon: Icon(hidePassword
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 70,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Update Password',
                  colors: kTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'Current Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            style: const TextStyle(fontSize: 16),
                            decoration: getInputDecoration(
                              'Current Password',
                              Icons.vpn_key,
                            ),
                            obscureText: hidePassword,
                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Can not be empty';
                              }
                            },
                            onSaved: (value) {
                              _passwordData['oldPassword'] = value.toString();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'New Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            style: const TextStyle(fontSize: 16),
                            decoration: getInputDecoration(
                              'New Password',
                              Icons.vpn_key,
                            ),
                            obscureText: hidePassword,
                            controller: _passwordController,
                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (value) {
                              _passwordData['newPassword'] = value.toString();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'Confirm Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            style: const TextStyle(fontSize: 16),
                            decoration: getInputDecoration(
                              'Confirm Password',
                              Icons.vpn_key,
                            ),
                            obscureText: hidePassword,
                            // ignore: missing_return
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: MaterialButton(
                              onPressed: _submit,
                              child: const Text(
                                'Update Now',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              color: kRedColor,
                              textColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              splashColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                side: const BorderSide(color: kRedColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
