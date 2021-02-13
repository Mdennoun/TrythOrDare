import 'dart:async';

import 'package:flutter/material.dart';
import 'package:truth_or_dare/Question.dart';
import 'http_service.dart';
import 'question.dart' as qs;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());
Future<String> get() async {
  var url = "https://thuth-dare.herokuapp.com/api/thruth";
  final response =
  await http.get(url);

  if (response.statusCode != 200) {
    throw Error();
  }
  final jsonBody = json.decode(response.body) as Map<String, dynamic>;
//final Question qes = Question.fromJson(jsonBody);

  return jsonBody['response'];
}

Future<void> getdemander() async {
  var url = "https://thuth-dare.herokuapp.com/api/set/thruth";
  final response =
  await http.get(url);

  if (response.statusCode != 200) {
    throw Error();
  }
  final jsonBody = json.decode(response.body) as Map<String, dynamic>;
//final Question qes = Question.fromJson(jsonBody);

}

void demander() async {
  await getdemander();
}

Future<String> qes;
void getQuestion() async {
  qes = get();
  ques = await qes;
  print(ques);
}
String ques;

Color backgroundColorStart = Colors.blueGrey;
Color backgroundColorEnd = Colors.blueGrey;
Color backColor = backgroundColorStart;
int test = 0;


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truth or Dare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Truth or Dare'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  AnimationController _controller;
  int levelClock = 60;

  void _get_qestion() {
    setState(() {
      backColor = backgroundColorStart;
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
    );

    _controller.forward();
      getQuestion();
    });
  }
  void _newquestion() {
    setState(() {
      backColor = backgroundColorStart;
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
    );

    _controller.forward();
      demander();
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
     Future<String> u =  get();

    return
      FutureBuilder(
      future: get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            if (snapshot.hasData) {

              final String user =  snapshot.data;
              if (user == null) {
                return Center(
                  child: Text("data"),
                );
              }

              return Scaffold(


                appBar: AppBar(
                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: Text(widget.title),
                  backgroundColor: Colors.blueGrey,
                ),
                body: Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.

                  child: Column(

                    // Column is also a layout widget. It takes a list of children and
                    // arranges them vertically. By default, it sizes itself to fit its
                    // children horizontally, and tries to be as tall as its parent.
                    //
                    // Invoke "debug painting" (press "p" in the console, choose the
                    // "Toggle Debug Paint" action from the Flutter Inspector in Android
                    // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                    // to see the wireframe for each widget.
                    //
                    // Column has various properties to control how it sizes itself and
                    // how it positions its children. Here we use mainAxisAlignment to
                    // center the children vertically; the main axis here is the vertical
                    // axis because Columns are vertical (the cross axis would be
                    // horizontal).
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[
                      Container(


                        width: 350,
                        height: 310,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: backColor,
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                            <Widget>[
                              Countdown(
                                animation: StepTween(
                                  begin: levelClock, // THIS IS A USER ENTERED NUMBER
                                  end: 0,
                                ).animate(_controller),
                              ),



                              const ListTile(
                              title: Text('Question :', style: TextStyle(color: Colors.white)),
                            ),

                              Text(user  , style: TextStyle(color: Colors.white)),
                              Text("\n"  , style: TextStyle(color: Colors.white)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text("afficher", style: TextStyle(color: Colors.white)),
                                    onPressed: _get_qestion,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 5),
                                  RaisedButton(
                                    child: Text("demander", style: TextStyle(color: Colors.white)),
                                    onPressed: _newquestion,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
                /**floatingActionButton: FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: Icon(Icons.arrow_forward_ios_sharp),
                    ), // This trailing comma makes auto-formatting nicer for build methods.
                 **/
              );

            } else {
              return Center(

                child: Text("${snapshot.data}"),
              );
            }
            break;

          default:
            return Container();
            break;
        }
      },
    );



  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
    if (clockTimer.inSeconds == 0) {

      backColor = Colors.blueGrey;
    }

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 70,
        color: Colors.white,
      ),
    );
  }
}

