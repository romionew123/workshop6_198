import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workshop6_198/screens/formscreen.dart';
import 'package:workshop6_198/screens/display.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Score App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        body: const TabBarView(
          children: [
            FormScreen(),
            DisplayScreen(),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 49, 224, 157),
        bottomNavigationBar: TabBar(
          tabs: const [
            Tab(
              text: "บันทึกคะแนน",
              icon: Icon(Icons.note_add),
            ),
            Tab(
              text: "รายชื่อนักเรียน",
              icon: Icon(Icons.list),
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.white,
        ),
      ),
    );
  }
}