import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignUpPage(),
  ));
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  String? profession = "Profession";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: Column(children: [
      const SizedBox(
        height: 30,
      ),
      logoWidget(),
      const SizedBox(
        height: 30,
      ),
      signUpCurve(),
      buildName(),
      buildPassword(),
      buildEmail(),
      buildPhoneNumber(),
      const SizedBox(
        height: 10,
      ),
      professionWidget(),
      const SizedBox(
        height: 5,
      ),
      signUpButtonWidget(),
      signInButtonWidget(),
    ]))));
  }

  void setDetails(username, password, email) async {
    final SharedPreferences userDetails = await SharedPreferences.getInstance();
    userDetails.setString("username", username);
    userDetails.setString("password", password);
    userDetails.setString("email", email);
  }

  Widget logoWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/geek_synergy_logo.jpg",
              width: 120,
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

  Widget signUpCurve() {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(
              width: 10,
            ),
            Text(
              " Sign Up",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              "Create an Account to start using Geek Synergy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            )
          ],
        )
      ],
    );
  }

  Widget buildName() => buildTitle(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            controller: _username,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
              hintText: 'Enter Your Name',
            ),
          ),
        ),
      );
  Widget buildPassword() => buildTitle(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            controller: _password,
            validator: (value) => "Please enter password",
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              hintText: 'Enter Password',
            ),
          ),
        ),
      );
  Widget buildEmail() => buildTitle(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            controller: _email,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              hintText: 'Enter Your Email Id',
            ),
          ),
        ),
      );
  Widget buildPhoneNumber() => buildTitle(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            controller: _phoneNumber,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phone Number',
              hintText: 'Enter Your Phone Number',
            ),
          ),
        ),
      );
  Widget signUpButtonWidget() {
    return ElevatedButton(
      child: const Text('SIGN UP'),
      onPressed: () {
        setDetails(_username.text, _password.text, _email.text);
        if (kDebugMode) {
          print("_password, _username::$_password,$_username");
        }

        if (_username.text.isNotEmpty &&
            _password.text.isNotEmpty &&
            _email.text.isNotEmpty) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LogInPage()));
        }
      },
    );
  }

  Widget professionWidget() {
    return SizedBox(
      height: 50,
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "$profession",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              DropdownButton<String>(
                items: <String>['Engineer', 'Former', 'Doctor', 'Police']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  profession = value!;
                  setState(() {});
                },
              ),
            ],
          ),

        ),
      ),
    );
  }

  Widget signInButtonWidget() {
    return Row(children: [
      const SizedBox(
        width: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("Already a member?"),
          const SizedBox(
            width: 20,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LogInPage()));
              },
              child: const Text(
                "SIGN IN",
                style: TextStyle(color: Colors.pink, fontSize: 20),
              ))
        ],
      )
    ]);
  }

  Widget buildTitle({
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          child,
        ],
      );
}
