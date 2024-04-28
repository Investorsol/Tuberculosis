import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: HighRiskTuberculosisPage(userID: 'user123'),
  ));
}

class HighRiskTuberculosisPage extends StatelessWidget {
  final String userID;

  const HighRiskTuberculosisPage({Key? key, required this.userID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('High Risk: Tuberculosis'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              color: Colors.white,
              child: TabBar(
                tabs: [
                  Tab(text: 'Schedule Appointment'),
                  Tab(text: 'Appointment History'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.all(16.0), // Add padding here
              decoration: BoxDecoration(
                color: Colors.grey[200], // Add a background color here
                borderRadius: BorderRadius.circular(10.0), // Optional: Add rounded corners
              ),
              child: AppointmentSchedulingPage(userID: userID),
            ),
            Container(
              padding: EdgeInsets.all(16.0), // Add padding here
              decoration: BoxDecoration(
                color: Colors.grey[200], // Add a background color here
                borderRadius: BorderRadius.circular(10.0), // Optional: Add rounded corners
              ),
              child: AppointmentHistoryPage(userID: userID),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentSchedulingPage extends StatefulWidget {
  final String userID;

  const AppointmentSchedulingPage({Key? key, required this.userID})
      : super(key: key);

  @override
  _AppointmentSchedulingPageState createState() =>
      _AppointmentSchedulingPageState();
}

class _AppointmentSchedulingPageState
    extends State<AppointmentSchedulingPage> {
  String? _selectedHospital;
  String _pricing = '';
  String _appointmentDates = '';
  List<String> _hospitalNames = [];
  List<String> _filteredHospitalNames = [];
  DateTime? _selectedAppointmentDate;
  bool _isSubmitting = false; // Flag to control the circular progress indicator

  @override
  void initState() {
    super.initState();
    _fetchHospitalNames();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Text field for searching hospitals
        TextField(
          onChanged: _filterHospitalNames,
          decoration: InputDecoration(
            labelText: 'Search Hospital',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.0),
        // List of hospitals
        _filteredHospitalNames.isNotEmpty
            ? _buildHospitalList()
            : SizedBox.shrink(),
        SizedBox(height: 16.0),
        // Hospital details and appointment booking options
        _selectedHospital != null ? _buildHospitalDetails() : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildHospitalList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredHospitalNames.length,
        itemBuilder: (context, index) {
          final hospitalName = _filteredHospitalNames[index];
          return ListTile(
            title: Text(hospitalName),
            onTap: () {
              setState(() {
                _selectedHospital = hospitalName;
              });
              _fetchHospitalDetails(hospitalName);
            },
          );
        },
      ),
    );
  }

  Widget _buildHospitalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          ' Hospital: $_selectedHospital',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
        ),
        SizedBox(height: 8.0),
        Text('  Pricing: $_pricing', style: TextStyle(fontSize: 13.0),),
        SizedBox(height: 8.0),
        Text('  Appointment Dates: $_appointmentDates', style: TextStyle(fontSize: 13.0),),
        
        SizedBox(height: 16.0),
        Row(
          children: [
            SizedBox(width: 8.0),
            Text(
              'Select Appointment Date',
              style: TextStyle(fontSize: 15.0),
            ),
            GestureDetector(
              onTap: () => _selectAppointmentDate(context),
              child: Icon(Icons.calendar_today),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _isSubmitting ? null : () => _bookAppointment(context),
          child: _isSubmitting
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text('Book Now'),
        ),
      ],
    );
  }

  void _fetchHospitalNames() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Hospitals').get();
    List<String> hospitalNames = [];
    querySnapshot.docs.forEach((doc) {
      hospitalNames.add(doc['name']);
    });
    setState(() {
      _hospitalNames = hospitalNames;
      _filteredHospitalNames = hospitalNames;
    });
  }

  void _fetchHospitalDetails(String hospitalName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Hospitals')
          .where('name', isEqualTo: hospitalName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>; // Explicit cast
        setState(() {
          _pricing = data['pricing'] != null ? data['pricing'].toString() : ''; // Convert to string
          if (data['appointment_dates'] != null &&
              data['appointment_dates'] is List<dynamic>) {
            List<dynamic> timestamps = data['appointment_dates'];
            _appointmentDates = timestamps
                .map((timestamp) {
                  DateTime date = (timestamp as Timestamp).toDate();
                  return DateFormat('yyyy-MM-dd').format(date); // Format the date
                })
                .join(', ');
          } else {
            _appointmentDates = '';
          }
        });
      }
    } catch (e) {
      print('Error fetching hospital details: $e');
      setState(() {
        _pricing = '';
        _appointmentDates = '';
      });
    }
  }

  void _filterHospitalNames(String searchText) {
    setState(() {
      _filteredHospitalNames = _hospitalNames
          .where((hospital) =>
              hospital.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void _selectAppointmentDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedAppointmentDate = pickedDate;
      });
    }
  }

  void _bookAppointment(BuildContext context) async {
    // Check if the appointment date is selected
    if (_selectedAppointmentDate == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select an appointment date.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    
    // Set the flag to true when the submission starts
    setState(() {
      _isSubmitting = true;
    });

    // Check if the selected appointment date matches any of the available appointment dates
    bool isAppointmentAvailable = _appointmentDates.split(',').any((date) => date.trim() == DateFormat('yyyy-MM-dd').format(_selectedAppointmentDate!));

    if (!isAppointmentAvailable) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Selected appointment date is not available. Please select a valid appointment date.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      // Reset the flag when the submission is complete
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    try {
      // Check if there's already a pending appointment for the current user at the selected hospital
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Appointments')
        .where('userID', isEqualTo: widget.userID)
        .where('hospitalName', isEqualTo: _selectedHospital)
        .where('status', isEqualTo: 'pending')
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        // There's already a pending appointment, show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('You already have a pending appointment at this hospital.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // No pending appointment, proceed to submit the appointment
        await FirebaseFirestore.instance.collection('Appointments').add({
          'userID': widget.userID,
          'hospitalName': _selectedHospital,
          'appointmentDate': _selectedAppointmentDate,
          'status': 'pending',
        });
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Appointment submitted successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error booking appointment: $e');
    } finally {
      // Reset the flag when the submission is complete
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}


class AppointmentHistoryPage extends StatelessWidget {
  final String userID;

  const AppointmentHistoryPage({Key? key, required this.userID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .where('userID', isEqualTo: userID) // Filter appointments by userID
            .snapshots()
            .map((snapshot) => snapshot.docs),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('No appointment history found.'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var appointment =
                      snapshot.data![index].data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      ListTile(
                        title: Text(appointment['hospitalName']),
                        subtitle: Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(appointment['appointmentDate'].toDate())}',
                        ),
                        trailing: Text(
                          'Status: ${appointment['status']}',
                          style: TextStyle(
                            color: appointment['status'] == 'pending'
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
