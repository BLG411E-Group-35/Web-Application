import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/models/http_exception.dart';
import 'package:web_app/providers/UserProvider.dart';
import 'package:web_app/widgets/appBar.dart';
import 'package:web_app/widgets/buttons.dart';
import 'package:flutter/services.dart';

import '../themes/customTheme.dart';

class User extends StatefulWidget {
  static const routeName = "/users";
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool _isInit = false;
  bool isLoading = false;

  void showCreationPopUpMenu({oldData}) {
    showDialog(
      context: context,
      builder: (ctx) {
        Map<String, dynamic> userData = {};

        final GlobalKey<FormState> formKey = GlobalKey();
        bool isLoading = false;

        userData = {
          "name": oldData != null ? oldData["fullname"].split(' ')[0] : "",
          "surname": oldData != null ? oldData["fullname"].split(' ')[1] : "",
          "username": oldData != null ? oldData["username"] : "",
          "mail": oldData != null ? oldData["mail"] : "",
          "password": "",
        };

        return AlertDialog(
            title: const Text("Add new User."),
            content: StatefulBuilder(builder: ((context, setState) {
              Future<void> submit() async {
                if (formKey.currentState == null ||
                    !formKey.currentState!.validate()) {
                  // Invalid!
                  return;
                }

                formKey.currentState!.save();

                setState(() {
                  isLoading = true;
                });

                try {
                  if (oldData == null) {
                    await Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).createUser(userData);
                    showSnackbar(
                      "Successfully added!",
                      error: false,
                    );
                  } else {
                    userData["userId"] = oldData["userId"];
                    await Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).updateUser(userData);
                    showSnackbar(
                      "Successfully updated!",
                      error: false,
                    );
                  }
                  Navigator.of(context).pop();
                } on HttpException catch (error) {
                  showSnackbar(error.toString());
                }
                setState(() {
                  isLoading = false;
                });
              }

              return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          initialValue: userData["name"],
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Invalid name!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData["name"] = value;
                          },
                        ),
                        TextFormField(
                          initialValue: userData["surname"],
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Invalid Last Name!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData["surname"] = value;
                          },
                        ),
                        TextFormField(
                          initialValue: userData["username"],
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Invalid Username!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData["username"] = value;
                          },
                        ),
                        TextFormField(
                          initialValue: userData["mail"],
                          decoration: const InputDecoration(
                            labelText: 'Mail',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Invalid mail!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData["mail"] = value;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          initialValue: userData["password"],
                          decoration: const InputDecoration(
                            labelText: 'password',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          validator: (String? value) {
                            if (oldData == null) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid password!';
                              }

                              if (value.length < 5) {
                                return "Minimum length is 5";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData["password"] = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: submit,
                                child: Text(
                                  oldData == null ? "Create" : "Change",
                                ),
                              )
                      ],
                    ),
                  ));
            })));
      },
    );
  }

  void showSnackbar(String msg, {bool error = true}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<UserProvider>(context).fetchUsers().then((_) {
        // print(Provider.of<UserProvider>(context, listen: false).items);
      }).catchError(
        (error) {
          print(error);
        },
      );
      _isInit = true;
      setState(() {
        isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: const CustomAppBarContent(),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<UserProvider>(
                builder: (ctx, users, _) => Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        ...users.items.map(
                          (e) => SizedBox(
                            key: ObjectKey(e["userId"]),
                            width: screenSize.width * 0.9,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: ExpansionTileCard(
                                baseColor: CustomTheme.Color3,
                                expandedColor: CustomTheme.Color4,
                                elevation: 12,
                                contentPadding: const EdgeInsets.all(10.0),
                                leading: Image.network(e["picture"]["link"]),
                                title: Text(e["fullname"]),
                                subtitle: Text(e["username"]),
                                // childrenPadding: const EdgeInsets.all(10),
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: const [
                                        Flexible(
                                          child: Center(
                                            child: Text("Gender"),
                                          ),
                                        ),
                                        Flexible(
                                          child: Center(
                                            child: Text("Birth Date"),
                                          ),
                                        ),
                                        Flexible(
                                          child: Center(
                                            child: Text("E-mail"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Center(
                                          child: Text(e["gender"] ?? "unknown"),
                                        ),
                                      ),
                                      Flexible(
                                        child: Center(
                                          child:
                                              Text(e["birthdate"] ?? "unknown"),
                                        ),
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(e["mail"] ?? "unknown"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: IconWithTextElevatedButton(
                                          text: "Edit",
                                          icon: Icons.edit,
                                          callback: () {
                                            showCreationPopUpMenu(oldData: e);
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: IconWithTextElevatedButton(
                                          text: "Remove",
                                          icon: Icons.delete,
                                          callback: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(
                                                    "Remove ${e["workoutName"]}"),
                                                content: const Text(
                                                    "Are you sure you want to delete this workout?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await users.removeUser(
                                                          e["userId"]
                                                              .toString(),
                                                        );
                                                        showSnackbar(
                                                          "Successfully Removed",
                                                          error: false,
                                                        );
                                                      } catch (err) {
                                                        showSnackbar(
                                                            err.toString());
                                                      }
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: const Text("Yes"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(ctx).pop(),
                                                    child: const Text("No"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
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
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreationPopUpMenu();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
