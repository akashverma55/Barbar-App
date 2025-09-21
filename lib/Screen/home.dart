import 'package:firebase_app/Data/shared.dart';
import 'package:firebase_app/Screen/booking.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app/Data/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Data data = Data();
  String? Name, ProfileImage, Email;

  Future<void> dataFromSharedPreference() async{
    Name = await Shared().getUserName();
    ProfileImage = await Shared().getUserImage();
    Email = await Shared().getUserEmail();
    setState(() {});
  }

  @override
  void initState(){
    dataFromSharedPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> Services = data.services;
    return Scaffold(
      backgroundColor: Color(0xFF2b1615),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                          color: Colors.white60,
                        ),
                      ),
                      Text(
                        Name?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(ProfileImage??"")
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey[500]),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: Services.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(context)=> Booking(
                          service: Services[index]["Service"], 
                          name: Name!, 
                          profileImage: ProfileImage!, 
                          email: Email!,
                          image: Services[index]['BookingImage']
                          )
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 151, 112),
                          border: Border.all(width: 2, color: Colors.grey[500]!),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                Services[index]["Image"],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              Services[index]["Service"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
