import 'package:gusto/auth.dart';
import 'package:gusto/pages/authentication/auth_page.dart';
import 'package:gusto/navigation/screens.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }else if (snapshot.hasError){
          return const Center( child: Text('Something went wrong!'));
        } else if (snapshot.hasData) {
          return const Screens();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
