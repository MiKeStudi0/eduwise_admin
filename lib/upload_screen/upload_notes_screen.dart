import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPdfScreen extends StatefulWidget {
  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  TextEditingController _courseController = TextEditingController();
  TextEditingController _degreeController = TextEditingController(); // New controller
  TextEditingController _departmentController = TextEditingController(); // New controller
  String? _selectedUniversityId;
  String? _selectedDegreeId;
  String? _selectedDepartment;
  String? _selectedSemesterId;
  String? _selectedCourseId;
  String? _selectedCategoryId;
    File? _pickedPdf;
  String? _pdfUrl;

Future<Map<String, dynamic>?> getTwoFieldsFromCollection(String collectionPath, String documentId, String courseCode, String courseCredit) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(collectionPath).doc(documentId).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return {
        'courseCode': data[courseCode],
        'courseCredit': data[courseCredit],
      };
    } else {
      print('Document does not exist');
      return null;
    }
  } catch (e) {
    print('Error retrieving fields: $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category uploadzz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('/University').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> universitySnapshot) {
                  if (universitySnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!universitySnapshot.hasData || universitySnapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No universities found'),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select a University ID:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Select a University ID'),
                        value: _selectedUniversityId,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUniversityId = newValue;
                            _selectedDegreeId = null;
                            _selectedDepartment = null;
                            _selectedSemesterId = null; // Reset selected semester
                          });
                        },
                        items: universitySnapshot.data!.docs.map((DocumentSnapshot document) {
                          return DropdownMenuItem<String>(
                            value: document.id,
                            child: Text(
                              document.id,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      if (_selectedUniversityId != null)
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('/University/$_selectedUniversityId/Refers').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> degreeSnapshot) {
                            if (degreeSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!degreeSnapshot.hasData || degreeSnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No Degrees found for the selected University'),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select a Degree:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Select a Degree'),
                                  value: _selectedDegreeId,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedDegreeId = newValue;
                                      _selectedDepartment = null;
                                      _selectedSemesterId = null; // Reset selected semester
                                    });
                                  },
                                  items: degreeSnapshot.data!.docs.map((DocumentSnapshot document) {
                                    return DropdownMenuItem<String>(
                                      value: document.id,
                                      child: Text(
                                        document.id,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      if (_selectedDegreeId != null)
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> departmentSnapshot) {
                            if (departmentSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!departmentSnapshot.hasData || departmentSnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No Department found for the selected Degree'),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select a Department:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Select a Department'),
                                  value: _selectedDepartment,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedDepartment = newValue;
                                      _selectedSemesterId = null; // Reset selected semester
                                    });
                                  },
                                  items: departmentSnapshot.data!.docs.map((DocumentSnapshot document) {
                                    return DropdownMenuItem<String>(
                                      value: document.id,
                                      child: Text(
                                        document.id,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      if (_selectedDepartment != null)
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> semesterSnapshot) {
                            if (semesterSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!semesterSnapshot.hasData || semesterSnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No Semester found for the selected Department'),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select a Semester:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Select a Semester'),
                                  value: _selectedSemesterId,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedSemesterId = newValue;
                                    });
                                  },
                                  items: semesterSnapshot.data!.docs.map((DocumentSnapshot document) {
                                    return DropdownMenuItem<String>(
                                      value: document.id,
                                      child: Text(
                                        document.id,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      if (_selectedSemesterId != null)
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers/$_selectedSemesterId/Refers').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> CourseSnapshot) {
                            if (CourseSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!CourseSnapshot.hasData || CourseSnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No Course found for the selected Department'),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select a Course:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Select a Course'),
                                  value: _selectedCourseId,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCourseId = newValue;
                                    });
                                  },
                                  items: CourseSnapshot.data!.docs.map((DocumentSnapshot document) {
                                    return DropdownMenuItem<String>(
                                      value: document.id,
                                      child: Text(
                                        document.id,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                        ),
                           const SizedBox(height: 20),
                      if (_selectedCourseId != null)
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers/$_selectedSemesterId/Refers/$_selectedCourseId/Refers').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> categorySnapshot) {
                            if (categorySnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!categorySnapshot.hasData || categorySnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No Category found for the selected Department'),
                              );
                            }
                            return Column(  
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select a Category:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Select a Category'),
                                  value: _selectedCategoryId,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCategoryId = newValue;
                                    });
                                  },
                                  items: categorySnapshot.data!.docs.map((DocumentSnapshot document) {
                                    return DropdownMenuItem<String>(
                                      value: document.id,
                                      child: Text(
                                        document.id,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      
                      const SizedBox(height: 10),
                     
                       ElevatedButton(
                onPressed: _pickPdf,
                child: Text(_pickedPdf == null ? 'Pick PDF' : 'PDF Selected'),
              ),
                      ElevatedButton(
                        onPressed: (_selectedUniversityId != null &&
                            _selectedDegreeId != null &&
                            _selectedDepartment != null &&
                            _selectedSemesterId != null
                            && _pickedPdf != null)
                            ? () {
                          String path =
                              '/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers/$_selectedSemesterId/Refers';
                          print('Generated Path: $path');
                          _createSubcollection();
                        }
                            : null,
                        child: const Text('Create Subcollection'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

   // Function to pick a PDF file
  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedPdf = File(result.files.single.path!);
      });
    }
  }
Future<void> _createSubcollection() async {
  // Check if PDF is selected
  if (_pickedPdf == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please select a PDF file.'),
      backgroundColor: Colors.red,
    ));
    return;
  }

  // Reference to the collection
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers/$_selectedSemesterId/Refers/$_selectedCourseId/Refers/$_selectedCategoryId/Refers/');

  // Extract PDF filename
  String? fileName = _selectedCourseId; // Use course name as file name

  // Upload PDF to Firebase Storage with course name as document name
  Reference ref = FirebaseStorage.instance.ref().child('pdfs/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers/$_selectedSemesterId/Refers/$_selectedCourseId/Refers/$_selectedCategoryId/Refers/$_selectedCourseId/Refers/$fileName.pdf');
  TaskSnapshot uploadTask = await ref.putFile(_pickedPdf!);
  String pdfUrl = await uploadTask.ref.getDownloadURL();


  String courseCode = 'courseCode'; // Replace with the name of the first field you want to retrieve
  String courseCredit = 'courseCredit'; // Replace with the name of the second field you want to retrieve
  
  Map<String, dynamic>? fields = await getTwoFieldsFromCollection('/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers/$_selectedSemesterId/Refers', '$_selectedCourseId', courseCode, courseCredit);
  
  if (fields != null) {
    
    print('Field 1 value: ${fields['courseCode']}');
    courseCredit = fields['courseCredit'];
    courseCode = fields['courseCode'];
    print('Field 2 value: ${fields['courseCredit']}');
  } else {
    print('Fields not found');
  }
   courseCredit = fields!['courseCredit'];
    courseCode = fields['courseCode'];

    // Generate the data for the new document
    Map<String, dynamic> data = {
      'courseCode': fields['courseCredit'],
      'courseCredit': fields['courseCode'],
      'Semester': _selectedSemesterId,
      'University': _selectedUniversityId,
      'courseName': _selectedCourseId,
      'Department': _selectedDepartment,
      'Degree': _selectedDegreeId,
      'pdfUrl': pdfUrl,
    };

    // Create the document in Firestore
    await collectionRef.doc(_selectedCourseId).set(data);

    // Show a SnackBar indicating success
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Subcollection created successfully.'),
    ));
}

}