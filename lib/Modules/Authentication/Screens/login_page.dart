import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geek_synergy/Modules/Authentication/Screens/sign_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Home/Screens/home_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() {
    return _LogInPageState();
  }
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? user;
  String? pass;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    logoWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    signInCurveWidget(),
                    buildName(),
                    buildPassword(),
                    signInButtonWidget(),
                    signUpWidget(),
                  ])))),
    );
  }

  Widget logoWidget(){
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/geek_synergy_logo.jpg",
              width: 90,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: const [
                Text(
                  "GEEK-SYNERGY",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ],
    );

  }

  Widget signInCurveWidget(){
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              " Sign In",
              style: TextStyle(
                  fontSize: 27, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text(
              "Welcome to Geek Synergy sign in \nwith Your details",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ],
    );
  }


  Widget buildName() => buildTitle(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _username,
        obscureText: false,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'UserName',
          hintText: 'Enter Your name',
        ),
      ),
    ),
  );
  Widget buildPassword() => buildTitle(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextFormField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              hintText: 'Enter Password',
            ),
          ),
        ),
      );

  Widget signInButtonWidget(){
    return ElevatedButton(
        child: const Text('SIGN IN'),
        onPressed: () {
          getDetails();
        });
  }
  Widget signUpWidget(){
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Don't have a account?"),
            const SizedBox(
              width: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                      const SignUpPage()));
                },
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(
                      color: Colors.pink, fontSize: 20),
                ))
          ],
        )
      ],
    );
  }

  void getDetails() async {
    final SharedPreferences userDetails = await SharedPreferences.getInstance();
    user = userDetails.getString('username');
    pass = userDetails.getString('password');
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    if (user == _username.text && pass == _password.text) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      if (kDebugMode) {
        print("log in failed");
      }
      showInSnackBar("Invalid Credentials");
    }
    if (kDebugMode) {
      print("$user $pass");
    }
  }


  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      backgroundColor: Colors.red,
    ));
  }

  Widget buildTitle({
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
        ],
      );
}
