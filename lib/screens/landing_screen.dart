import 'package:academy_app/screens/auth_screen.dart';
import 'package:academy_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: SizedBox()),
          Image.asset("assets/images/text_logo.png"),
          Expanded(flex: 5, child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width * .4,
                color: Color(0xFF00339E),
                onPressed: () {
                  Navigator.of(context).pushNamed(SignUpScreen.routeName);
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white)),
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width * .4,
                color: Color(0xFF00339E),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => AuthScreen()));
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
