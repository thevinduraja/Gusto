import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../auth.dart';
import 'package:flutter/gestures.dart';

class Signup extends StatefulWidget {
  final VoidCallback onClickedLogin;

  const Signup({Key? key, required this.onClickedLogin}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String _password = '';
  String _confirmPassword = '';

  Future<void> createUserWithEmailAndPassword() async {
    try {
      if (_confirmPassword.isEmpty) {
        Fluttertoast.showToast(
            msg: "Password cannot be empty!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
      else if(_confirmPassword != _password){
        Fluttertoast.showToast(
            msg: "Passwords do not match!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
      else{
        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      }

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
                margin: const EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 40.0),
                child: const Text('Welcome Onboard!',
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
                margin: const EdgeInsets.fromLTRB(15, 30.0, 15.0, 0.0),
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
                  onChanged: (value){
                    _password = value;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 30.0, 15.0, 40.0),
                child: TextField(
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    fillColor: Colors.white,
                  ),
                    onChanged: (value){
                      _confirmPassword = value;
                    },
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    createUserWithEmailAndPassword();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: const Color(0xFFFF7A00),
                      fixedSize: const Size(360, 55)
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),)
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 35.0, 0, 0.0),
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
                        text: 'Already a member? ',
                      ),
                      TextSpan(
                        text: ' Login',
                        style: const TextStyle (
                          fontFamily: 'Lato',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          color: Color(0xffff8900),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedLogin,
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
