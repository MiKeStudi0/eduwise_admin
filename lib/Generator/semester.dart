import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SemesterUpload extends StatefulWidget {
  @override
  _SemesterUploadState createState() => _SemesterUploadState();
}

class _SemesterUploadState extends State<SemesterUpload> {
  String? _selectedUniversityId;
  String? _selectedDegreeId;
  String? _selectedDepartment;

  // Define a list of predefined document names
  final List<String> predefinedDocumentNames = [
    'S1',
    'S2',
    'S3',
    'S4',
    'S5',
    'S6',
    'S7',
    'S8',
    // Add more predefined names as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Document IDs Dropdown'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // University Dropdown
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
                  ],
                );
              },
            ),

            // Degree Dropdown
            if (_selectedUniversityId != null)
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('/University/$_selectedUniversityId/Refers')
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
                      child:
                          Text('No Degrees found for the selected University'),
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
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),

            // Course Dropdown
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
                      child: Text('No Course found for the selected Degree'),
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
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),

            // Create Subcollection Button
            ElevatedButton(
              onPressed: (_selectedUniversityId != null &&
                      _selectedDegreeId != null &&
                      _selectedDepartment != null)
                  ? () {
                      String path =
                          '/University/$_selectedUniversityId/Refers/$_selectedDegreeId/Refers/$_selectedDepartment/Refers';
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                
              },
              child: const Text('Go course',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createSubcollection(String path) async {
    // Select a predefined document name from the list

    for (var i = 0; i < predefinedDocumentNames.length; i++) {
      print(predefinedDocumentNames[i]);

      final String documentName = predefinedDocumentNames[i];
      final String fullPath = '$path/$documentName';
      // Construct the full path with the selected document name

      // Show a SnackBar with the selected document name
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Creating document with name: $documentName'),
      ));

      try {
        // Create the document in Firestore
        await FirebaseFirestore.instance.doc(fullPath).set({});

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Document created successfully at: $fullPath'),
        ));
      } catch (error) {
        // Show error message if document creation fails
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create document: $error'),
        ));
      }
    }
  }
}
