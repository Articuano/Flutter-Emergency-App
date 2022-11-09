import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {});
    });
  }

  void _incrementCounter() async{
    setState(() {
      _counter++;
      this.preferences?.setInt("counter", _counter);
    });
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
    this.preferences?.setString("name", "Peter");
    this.preferences?.setStringList("infoList", ["developer","mobile dev"]);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController mailController = TextEditingController(text: "Help! This is an emergency text sent as a call for help. Call the sender or police for assistance.",);
    String N1String = "";
    String N2String = "";
    String N3String = "";
    String N4String = "";
    TextEditingController N1Controller = TextEditingController();
    TextEditingController N2Controller = TextEditingController();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: TextFormField(
                      controller: mailController,
                      autofocus: false,
                      minLines: 2,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Text("Enter the emergency message to be sent above", style: TextStyle(fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: SizedBox(
                      width: 150,
                      height: 75,
                      child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          N1String = prefs.getString("N1").toString();
                          N2String = prefs.getString("N2").toString();
                          N3String = prefs.getString("N3").toString();
                          N4String = prefs.getString("N4").toString();
                          print(N1String);
                          print("OK");
                          if(await Permission.sms.request().isGranted){
                            sendSMS(message: mailController.text, recipients: [N1String,N2String,N3String,N4String]);
                          }
                          else{

                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87
                        ), child: const Text("Send SMS"),
                      ),
                    ),
                  ),
                  ],
              ),
            ),
          ),
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.black87, width: 4),
        ),
      ),
        child:
          LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints)
          {
            return Container(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.black87,
                        border: Border(
                            bottom: BorderSide(color: Colors.black87, width: 4)
                        )
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: Text('Enter contacts here', textScaleFactor: 1.5, style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InternationalPhoneNumberInput(onInputChanged: (value) async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() => N1Controller.text = value.phoneNumber.toString());
                      prefs.setString("N1", value.phoneNumber.toString());
                    },
                        textFieldController: N2Controller,
                    hintText: this.preferences?.getString("N1"),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InternationalPhoneNumberInput(
                        onInputChanged: (value) async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() => N1Controller.text = value.phoneNumber.toString());
                      prefs.setString("N2", value.phoneNumber.toString());
                    },
                    hintText: this.preferences?.getString("N2")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InternationalPhoneNumberInput(onInputChanged: (value) async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() => N1Controller.text = value.phoneNumber.toString());
                      prefs.setString("N3", value.phoneNumber.toString());},
                    hintText: this.preferences?.getString("N3"),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InternationalPhoneNumberInput(onInputChanged: (value) async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() => N1Controller.text = value.phoneNumber.toString());
                      prefs.setString("N4", value.phoneNumber.toString());},
                    hintText: this.preferences?.getString("N4"),),
                  ),
                ],
              ),
            );
          },)
      ),

    ],
        ),

      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
