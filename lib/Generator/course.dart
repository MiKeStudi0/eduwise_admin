import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Course_Generator extends StatefulWidget {
  @override
  _Course_GeneratorState createState() => _Course_GeneratorState();
}

class _Course_GeneratorState extends State<Course_Generator> {
  String? _selectedUniversityId;
  String? _selectedDegreeId;
  String? _selectedDepartment;
  String? _selectedSemesterId;
  String? _selectedPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Select Semester Dropdown'),
      ),
      body: Padding(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          _selectedPath = null; // Reset selected path
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                    _selectedPath = null; // Reset selected path
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
                            AsyncSnapshot<QuerySnapshot> courseSnapshot) {
                          if (courseSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!courseSnapshot.hasData ||
                              courseSnapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text(
                                  'No Course found for the selected Degree'),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select a Course:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('Select a Course'),
                                value: _selectedDepartment,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDepartment = newValue;
                                    _selectedSemesterId =
                                        null; // Reset selected semester
                                    _updateSelectedPath(); // Update selected path
                                  });
                                },
                                items: courseSnapshot.data!.docs
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
                  ],
                );
              },
            ),
            if (_selectedPath != null) ...[
              const SizedBox(height: 20),
              Text(
                'Select Semester:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(_selectedPath!)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No Semester found'),
                    );
                  }
                  return DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Select a Semester'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSemesterId = newValue;
                      });
                    },
                    value: _selectedSemesterId,
                    items: snapshot.data!.docs.map((DocumentSnapshot document) {
                      return DropdownMenuItem<String>(
                        value: document.id,
                        child: Text(
                          document.id,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_selectedUniversityId != null &&
                      _selectedDegreeId != null &&
                      _selectedDepartment != null &&
                      _selectedSemesterId != null)
                  ? () {
                      String path =
                          '/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers/$_selectedSemesterId/Refers';
                      print('Generated Path: $path');
                      _createSubcollection(path);
                    }
                  : null,
              child: const Text('Create Subcollection'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createSubcollection(String path) async {
    // Reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(path);

    // List of predefined document IDs
    List<String> predefinedDocumentIds = ['doc1', 'doc2', 'doc3']; // Add your predefined document IDs here

    // Create documents with predefined IDs
    for (String _course in predefinedDocumentIds) {
      // Generate the data for the new document
      Map<String, dynamic> data = {
        'Degree': _selectedDegreeId,
        'Department': _selectedDepartment,
        'Semester': _selectedSemesterId,
        'University': _selectedUniversityId,
        'Course': _course,
        // Add more fields if needed
      };

      // Create the document with the predefined ID
      await collectionRef.doc(_course).set(data);
    }

    // Show a SnackBar indicating success
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Subcollection created successfully for Path: $path'),
    ));
  }

  void _updateSelectedPath() {
    setState(() {
      _selectedPath =
          '/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers';
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: Course_Generator(),
  ));
}
