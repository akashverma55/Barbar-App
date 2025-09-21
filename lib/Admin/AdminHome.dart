import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/Data/database.dart';
import 'package:flutter/material.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  Database databaseService = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "All Bookings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2b1615),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: databaseService.getBookings(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong!!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.brown)));
          }
          if(!snapshot.hasData||snapshot.data!.docs.isEmpty){
            return Center(child: Text("No bookings found!!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.brown)));
          }
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                Map<String,dynamic> bookingData = ds.data() as Map<String,dynamic>;
                return Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Color.fromARGB(255, 92, 46, 44)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            bookingData['Image'],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Service"),
                                    Text("Name"),
                                    Text("Date"),
                                    Text("Time"),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(" : ${bookingData['Service']??''}"),
                                    Text(" : ${bookingData['Name']??''}"),
                                    Text(" : ${bookingData['Date']??''}"),
                                    Text(" : ${bookingData['Time']??''}"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xffBC556f),
                                side: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 245, 206, 215),
                                ),
                                shadowColor: Colors.white,
                              ),
                              onPressed: () async{
                                await Database().deleteUserBooking(ds.id);
                              },
                              child: Text(
                                "Done",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
