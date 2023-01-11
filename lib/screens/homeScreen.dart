import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/providers/UserProvider.dart';
import 'package:web_app/widgets/appBar.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInit = false;
  bool _isLoading = false;

  Map<String, int> statistics = {};

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context).fetchStatistics().then((map) {
        statistics = map;
        setState(() {
          _isLoading = false;
        });
      }).catchError(
        (error) {
          print(error);
          setState(() {
            _isLoading = false;
          });
        },
      );
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    List _isHovering = [false, false, false, false];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: const CustomAppBarContent(),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(70),
                    child: Consumer<UserProvider>(
                      builder: (context, provider, _) => Column(
                        children: [
                          const Center(
                            child: InkWell(
                              child: Text(
                                "Today’s Accomplishments:",
                                style: TextStyle(
                                    fontSize: 50, color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  width: 592,
                                  height: 450,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFDBD56E)),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: _isLoading
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              "${statistics['login']}\nUsers Logged In",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 100),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 592,
                                  height: 450,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFDBD56E)),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: _isLoading
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              "${statistics['workout']}\nExercises Done",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 100),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
