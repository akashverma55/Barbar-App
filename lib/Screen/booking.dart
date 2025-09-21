import 'package:firebase_app/Data/database.dart';
import 'package:firebase_app/Screen/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  final String service;
  final String name;
  final String profileImage;
  final String email;
  final String image;
  const Booking({
    super.key, 
    required this.service, 
    required this.name, 
    required this.profileImage, 
    required this.email, 
    required this.image
  });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? DateString, TimeString;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        DateString = DateFormat.yMMMd().format(_selectedDate!);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        TimeString = DateFormat('h:mm a').format(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          ),
        );
      });
    }
  }

  Future<void> _booking() async {
    Map<String, dynamic> userBookingDetail = {
      "Service": widget.service,
      "Date": DateString,
      "Time": TimeString,
      "Name": widget.name,
      "Image": widget.profileImage,
      "Email": widget.email
    };

    await Database().addUserBooking(userBookingDetail).then((Value){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Service has been booked successfully!!!")));
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b1615),
      appBar: AppBar(
        backgroundColor: Color(0xFF2b1615),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: 40),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  "Let's the journey begin",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    widget.image,
                    height: 225,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white, thickness: 2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.service,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white, thickness: 2)),
                ],
              ),
              SizedBox(height: 20),
              dateTime(context, date: true),
              SizedBox(height: 20),
              dateTime(context, date: false),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFb4817e),
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 60),
                  elevation: 10,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(width: 1, color: Colors.white),
                ),
                onPressed: _booking,
                child: Text(
                  "Book Now",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }

  Widget dateTime(BuildContext context, {required bool date}) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFb4817e),
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            date ? "Date" : "Time",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 10,
              backgroundColor: Color(0xFF2b1615),
              minimumSize: Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: date ? _selectDate : _selectTime,
            child: Row(
              children: [
                Icon(
                  date ? Icons.calendar_month : Icons.alarm,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 20),
                Text(
                  date
                      ? _selectedDate == null
                            ? 'Select the Date'
                            : DateString!
                      : _selectedTime == null
                      ? 'Select the Time'
                      : TimeString!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
