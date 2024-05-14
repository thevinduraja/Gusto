import 'package:flutter/material.dart';
import 'package:gusto/pages/authentication/login.dart';
import 'package:gusto/pages/authentication/signUp.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? Login(onClickedSignUp: toggle) : Signup(onClickedLogin: toggle);

  void toggle() => setState( () => isLogin = !isLogin);
}
