import 'package:chatappflutter/widget/auth/picker/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFunction, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String name,
    File image,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFunction;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  String _userMail = '';
  String _userName = '';
  String _userPassword = '';
  var _isLogin = true;
  File userImageFile;

  void _pickedImage(File image) {
    userImageFile = image;
  }

  void isSubmitted() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add a image!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
        
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFunction(
        _userMail.trim(),
        _userName.trim(),
        userImageFile,
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userMail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('name'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'User name must be at least then 4 characters ';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'User name',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least then 7 characters ';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(_isLogin ? 'Login' : 'SingUp'),
                      onPressed: isSubmitted,
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(_isLogin
                          ? 'Create a new account'
                          : 'I have already account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
