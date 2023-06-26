
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'Student_Attendence.dart';

class EditDialog extends StatefulWidget {
  final List<dynamic> eventData;
   String id;
   String name;
   String gender;
   String number;
   String className;
  String schoolName;
   String selectedEvent;

  EditDialog({
    required this.id,
    required this.name,
    required this.gender,
    required this.number,
    required this.className,
    required this.schoolName,
    required this.selectedEvent,
    required this.eventData,
  });

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late String selected_event_id;
  late TextEditingController studentnameController;
  late String selectedGender;
  late TextEditingController phoneNumberController;
  late TextEditingController classController;
  late TextEditingController schoolNameController;
  late TextEditingController selectedEventController;  

  @override
  void initState() {
    super.initState();
    studentnameController = TextEditingController(text: widget.name);
    selectedGender = 'Male';
    phoneNumberController = TextEditingController(text: widget.number);
    classController = TextEditingController(text: widget.className);
    schoolNameController = TextEditingController(text: widget.schoolName);
    selectedEventController = TextEditingController(text: widget.selectedEvent);
  }

  @override
  void dispose() {
    studentnameController.dispose();
    phoneNumberController.dispose();
    classController.dispose();
    schoolNameController.dispose();
    selectedEventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  //This is the Dialog to edit here I need to get values to edit 
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Edit Event',
                      style: TextStyle(
                        fontFamily: 'Bold',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: studentnameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                      items: ['Male', 'Female', 'Other'].map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(selectedGender),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Number',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: classController,
                      decoration: InputDecoration(
                        labelText: 'Class',
                      ),
                    ),
                    TextField(
                      controller: schoolNameController,
                      decoration: InputDecoration(
                        labelText: 'School Name',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TypeAheadFormField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: selectedEventController,
                        decoration: InputDecoration(
                          labelText: 'Select Event',
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        // Modify the filter logic based on your requirements
                        return widget.eventData
                            .where((event) =>
                        event['name'].toLowerCase().contains(pattern.toLowerCase()) ||
                            event['date'].toLowerCase().contains(pattern.toLowerCase()))
                            .map((event) => '${event['name']} - ${event['date']}')
                            .toList();
                      },
                      itemBuilder: (context, String suggestion) {
                        final eventName = suggestion.split(' - ')[0];
                        final eventDate = suggestion.split(' - ')[1];
                        return ListTile(
                          title: Text('$eventName - $eventDate'),
                        );
                      },
                      onSuggestionSelected: (String suggestion) {
                        final selectedEvent = widget.eventData.firstWhere(
                              (event) => '${event['name']} - ${event['date']}' == suggestion,
                        );
                        setState(() {
                          selectedEventController.text = suggestion;
                          final eventId = selectedEvent['event_id'];
                          // Access the event ID using event['id']
                          // Do whatever you need with the event ID
                          selected_event_id = eventId;
                          print('Selected event ID: $eventId');
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an event';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Make the HTTP PATCH request here
                        final id = widget.selectedEvent;
                        final url = 'http://139.59.29.21:8080/panchayat/students/edit';
                        // Add your code to send the PATCH request to the specified URL
                        // using the data from the input fields
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffF9B429),
                        onPrimary: Colors.black,
                      ),
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
