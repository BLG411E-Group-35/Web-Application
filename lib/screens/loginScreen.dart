import 'package:flutter/material.dart';
import 'package:web_app/screens/homeScreen.dart';
import 'package:web_app/screens/mainScreen.dart';
import 'package:web_app/widgets/appBar.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 100),
        child: CustomAppBarContent(),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
                maxWidth: viewportConstraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Stack(
                        children: [
                          Image.asset(
                            "lib/assets/images/background.jpg",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Center(
                        child: SizedBox(
                          width: screenSize.width * (0.8 / 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "INERTIA",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFFDBD56E),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'E-Mail',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (String? value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.contains('@')) {
                                      return 'Invalid email!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFFDBD56E),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  obscureText: true,
                                  validator: (String? value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 5) {
                                      return 'Password is too short!';
                                    }
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(HomePage.routeName);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.all(15.0),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
