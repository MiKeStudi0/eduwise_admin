import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category_Generator extends StatefulWidget {
  @override
  _Category_GeneratorState createState() => _Category_GeneratorState();
}

class _Category_GeneratorState extends State<Category_Generator> {
  String? _selectedUniversityId;
  String? _selectedDegreeId;
  String? _selectedDepartment;
  String? _selectedSemesterId;

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
                            AsyncSnapshot<QuerySnapshot> DepartmentSnapshot) {
                          if (DepartmentSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!DepartmentSnapshot.hasData ||
                              DepartmentSnapshot.data!.docs.isEmpty) {
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('Select a Department'),
                                value: _selectedDepartment,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDepartment = newValue;
                                    _selectedSemesterId =  null; // Reset selected semester
                                  });
                                },
                                items: DepartmentSnapshot.data!.docs
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
                            AsyncSnapshot<QuerySnapshot> SemesterSnapshot) {
                          if (SemesterSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!SemesterSnapshot.hasData ||
                              SemesterSnapshot.data!.docs.isEmpty) {
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                items: SemesterSnapshot.data!.docs
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
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(path);

    // Fetch all documents under the selected semester
    QuerySnapshot snapshot = await collectionRef.get();

    // List of predefined document IDs
    List<String> predefinedDocumentIds = [
      'Syllabus',
      'Notes',
      'Text Book',
      'Question Bank',
      'Question Paper',
      'Academic Calender',
      'Lab Manual',
      'Exam Table',
      'Credit System'
    ]; // Add your predefined document IDs here

    // Iterate through each document in the selected semester
    snapshot.docs.forEach((semesterDocument) async {
      // Create documents with predefined IDs inside each semester document
      for (String documentId in predefinedDocumentIds) {
        // Generate the data for the new document
        Map<String, dynamic> data = {
          'Degree': _selectedDegreeId,
          'Department': _selectedDepartment,
          'Semester': _selectedSemesterId,
          'University': _selectedUniversityId,
          'selectedDocumentId': documentId,
          // Add more fields if needed
        };

        // Create the document with the document ID
        await semesterDocument.reference.collection('Refers').doc(documentId).set(data);
      }
    });

    // Show a SnackBar indicating success
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Subcollection created successfully for Path: $path'),
    ));
  }
}
