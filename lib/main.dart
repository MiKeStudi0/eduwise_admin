import 'package:eduwise_admin/Dropdownlist.dart';
import 'package:eduwise_admin/adminpanel/card_data_gen.dart';
import 'package:eduwise_admin/adminpanel/categoryupload.dart';
import 'package:eduwise_admin/adminpanel/course.dart';
import 'package:eduwise_admin/adminpanel/courseadder.dart';
import 'package:eduwise_admin/adminpanel/coursegenerator.dart';
import 'package:eduwise_admin/adminpanel/degree.dart';
import 'package:eduwise_admin/adminpanel/department.dart';
import 'package:eduwise_admin/adminpanel/retrive.dart';
import 'package:eduwise_admin/adminpanel/semester.dart';
import 'package:eduwise_admin/firebase_options.dart';
import 'package:eduwise_admin/uploadscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyAppHomePage(),
    );
  }
}

class MyAppHomePage extends StatelessWidget {
  const MyAppHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('uploadscreen'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadDataPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Card_data_gen'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Carddata_gen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Category Upload not work'),
              onTap: () {
                // CategoryUpload(); this not working do check
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Course'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CourseUpload()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('courseadder'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => courseadder()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('course Generator'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CourseGenerator()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Degree'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DegreeUpload()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Department'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DepartmentUpload()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('retrieve'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RetrieveDocument()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('semester'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SemesterUpload()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('withpdf not work'),
              onTap: () {
                // CategoryUpload(); this also not work
              },
            ),
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text('dept. firestore'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirestoreListView()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('ktucourse'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirestoreListView()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('se'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirestoreListView()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.code),
              title: Text('dropdown'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirestoreListView()),
                );
              },
            ),
          ],
        ),
      ),
      body: Carddata_gen(),
    );
  }
}
