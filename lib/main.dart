import 'package:eduwise_admin/Generator/category.dart';
import 'package:eduwise_admin/Generator/course.dart';
import 'package:eduwise_admin/Generator/degree.dart';
import 'package:eduwise_admin/Generator/department.dart';
import 'package:eduwise_admin/Generator/semester.dart';
import 'package:eduwise_admin/firebase_options.dart';
import 'package:eduwise_admin/upload_screen/upload_notes_screen.dart';
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
                child: Center(
                  child: Text(
                    'Navigation Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.admin_panel_settings, color: Colors.red),
                    title: Text('Core Generator'),
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: ListTile(
                      leading: Icon(Icons.school, color: Colors.blue),
                      title: Text('Degree'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DegreeUpload()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: ListTile(
                      leading: Icon(Icons.book, color: Colors.blue),
                      title: Text('Department'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DepartmentUpload()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: ListTile(
                      leading: Icon(Icons.search, color: Colors.blue),
                      title: Text('Semester'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SemesterUpload()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: ListTile(
                      leading: Icon(Icons.map, color: Colors.blue),
                      title: Text('Course'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Course_Generator()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: ListTile(
                      leading: Icon(Icons.install_mobile, color: Colors.blue),
                      title: Text('Category'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category_Generator()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              
            ],
          ),
        ),
        body:  Center(
          child: UploadPdfScreen(),
        ));
  }
}
