import 'package:firebase_app/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Data data = Data();

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
                        "Hello",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                          color: Colors.white60,
                        ),
                      ),
                      Text(
                        "Akash Verma",
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
                    backgroundImage: NetworkImage(
                      "https://th.bing.com/th/id/OIP.oKuAQ4Z7v5FWK0JmqoMnUAHaHa?w=137&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3",
                    ),
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
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.brown[900],
                        border: Border.all(width: 1, color: Colors.white),
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
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            Services[index]["Service"],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
