import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../auth.dart';
import 'package:flutter/gestures.dart';

class Login extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const Login({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException {
      setState(() {
        Fluttertoast.showToast(
            msg: "E-mail/ Password is Incorrect",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFE9C8),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Image.asset('assets/Gusto-Mask.png'),
              Container(
                margin: const EdgeInsets.fromLTRB(8.0, 50.0, 0.0, 50.0),
                child: const Text('Welcome Back Chef!',
                  style: TextStyle (
                    fontFamily: 'Lemon',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0.0, 15.0, 0.0),
                child: TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 40.0, 15.0, 30.0),
                child: TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
                child: const Text(
                  'Forgot Password ?',
                  style: TextStyle (
                    fontFamily: 'Lato',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    color: Color(0xff4b4b4b),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    signInWithEmailAndPassword();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: const Color(0xFFFF7A00),
                      fixedSize: const Size(360, 55)
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),)
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50.0, 0, 0.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle (
                      fontFamily: 'Lato',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      color: Color(0xff000000),
                    ),
                    children: [
                      const TextSpan(
                        text: 'Not a member? ',
                      ),
                      TextSpan(
                        text: 'Sign up',
                        style: const TextStyle (
                          fontFamily: 'Lato',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          color: Color(0xffff8900),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

  // void _navigateToSignUp(BuildContext context) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => Signup()));
  // }
