import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/screens/homeScreen.dart';
import 'package:web_app/screens/mainScreen.dart';
import 'package:web_app/widgets/appBar.dart';

import '../models/http_exception.dart';
import '../providers/AuthProvider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'mail': '',
    'password': '',
  };

  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    var errorMessage = "Authentication failed.";
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      // Invalid!
      print("test");
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
        _authData["mail"]!,
        _authData["password"]!,
      );
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      errorMessage = "General error. Please try again later.";
      print(error);
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

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
                          child: Form(
                            key: _formKey,
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
                                          !value.contains('@')) {
                                        return 'Invalid email!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData["mail"] = value!;
                                    },
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
                                    onSaved: (value) {
                                      _authData["password"] = value!;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: _submit,
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
