import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Course_Generator extends StatefulWidget {
  @override
  _Course_GeneratorState createState() => _Course_GeneratorState();
}

class _Course_GeneratorState extends State<Course_Generator> {
  TextEditingController _courseController = TextEditingController();
  TextEditingController _degreeController = TextEditingController(); // New controller
  TextEditingController _departmentController = TextEditingController(); // New controller
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
                      TextFormField(
                        controller: _courseController,
                        decoration: InputDecoration(
                          labelText: 'Enter Course Name',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _degreeController,
                        decoration: InputDecoration(
                          labelText: 'Enter CourseCode',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _departmentController,
                        decoration: InputDecoration(
                          labelText: 'Enter CourseCredit',
                        ),
                      ),
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

  Future<void> _createSubcollection(String path) async {
    // Reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(path);

    String courseName = _courseController.text.trim(); // Get course name from input field
    String courseCode = _degreeController.text.trim(); // Get degree name from input field
    String courseCredit = _departmentController.text.trim(); // Get department name from input field

    // Check if all input fields are not empty
    if (courseName.isNotEmpty && courseCode.isNotEmpty && courseCredit.isNotEmpty) {
      // Generate the data for the new document
      Map<String, dynamic> data = {
        'courseCode': courseCode, // Use entered degree name
        'courseCredit': courseCredit, // Use entered department name
        'Semester': _selectedSemesterId,
        'University': _selectedUniversityId,
        'courseName': courseName, // Use entered course name
        'Department': _selectedDepartment,
        'Degree': _selectedDegreeId,
        // Add more fields if needed
      };

      // Create the document with the entered course name as the document ID
      await collectionRef.doc(courseName).set(data); // Use courseName as the document ID

      // Show a SnackBar indicating success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Subcollection created successfully for Path: $path'),
      ));
    } else {
      // Show error if any input field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all the input fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: Course_Generator(),
  ));
}
