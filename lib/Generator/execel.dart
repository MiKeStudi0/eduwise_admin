import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ExelSheetCourse extends StatefulWidget {
  // Assigning collection path within the class

  @override
  State<ExelSheetCourse> createState() => _ExelSheetCourseState();
}

class _ExelSheetCourseState extends State<ExelSheetCourse> {
 // State variables
  String? _selectedUniversityId;
  String? _selectedDegreeId;
  String? _selectedDepartment;
  String? _selectedSemesterId;
Future<void> _uploadData(File file) async {
  try {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        '/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers/$_selectedSemesterId/Refers');

    String csvString = await file.readAsString();
    List<List<dynamic>> csvData = CsvToListConverter().convert(csvString);

    // Skip the first row (heading row) when iterating through the CSV data
    for (int i = 1; i < csvData.length; i++) {
      List<dynamic> row = csvData[i]; // Get the current row
      Map<String, dynamic> record = {
        'courseName': row[0],
        'courseCode': row[1],
        'courseCredit': row[2],
        'University': _selectedUniversityId,
        'Degree': _selectedDegreeId,
        'Department': _selectedDepartment,
        'Semester': _selectedSemesterId,
      };
      await collectionRef.doc(row[0]).set(record); // Use courseName as document ID
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data uploaded successfully')),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error uploading data: $error')),
    );
  }
}

  Future<File?> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV to Firestore'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('/University')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> universitySnapshot) {
                  if (universitySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!universitySnapshot.hasData ||
                      universitySnapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No universities found'),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select a University ID:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                            _selectedSemesterId =
                                null; // Reset selected semester
                          });
                        },
                        items: universitySnapshot.data!.docs
                            .map((DocumentSnapshot document) {
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
                          stream: FirebaseFirestore.instance
                              .collection(
                                  '/University/$_selectedUniversityId/Refers')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> degreeSnapshot) {
                            if (degreeSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!degreeSnapshot.hasData ||
                                degreeSnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text(
                                    'No Degrees found for the selected University'),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select a Degree:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                      _selectedSemesterId =
                                          null; // Reset selected semester
                                    });
                                  },
                                  items: degreeSnapshot.data!.docs
                                      .map((DocumentSnapshot document) {
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
                          stream: FirebaseFirestore.instance
                              .collection(
                                  '/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> departmentSnapshot) {
                            if (departmentSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!departmentSnapshot.hasData ||
                                departmentSnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text(
                                    'No Department found for the selected Degree'),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select a Department:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Select a Department'),
                                  value: _selectedDepartment,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedDepartment = newValue;
                                      _selectedSemesterId =
                                          null; // Reset selected semester
                                    });
                                  },
                                  items: departmentSnapshot.data!.docs
                                      .map((DocumentSnapshot document) {
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
                          stream: FirebaseFirestore.instance
                              .collection(
                                  '/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> semesterSnapshot) {
                            if (semesterSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!semesterSnapshot.hasData ||
                                semesterSnapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text(
                                    'No Semester found for the selected Department'),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select a Semester:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                  items: semesterSnapshot.data!.docs
                                      .map((DocumentSnapshot document) {
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
                      Center(
                        child:   ElevatedButton(
              onPressed: () async {
                File? file = await _selectFile();
                if (file != null) {
                  _uploadData(file);
                }
              },
              child: Text('Select CSV File'),
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
}
