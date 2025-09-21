import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/Admin/AdminHome.dart';
import 'package:flutter/material.dart';

class Adminlogin extends StatefulWidget {
  const Adminlogin({super.key});

  @override
  State<Adminlogin> createState() => _AdminloginState();
}

class _AdminloginState extends State<Adminlogin> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _UserController = TextEditingController();
  final TextEditingController _PassController = TextEditingController();
  bool _isObscure = true;

  Future<void> _adminLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      FirebaseFirestore.instance.collection("Admin").where('Username',isEqualTo: _UserController.text.trim()).get().then((Snapshot){
        if(Snapshot.docs.isNotEmpty){
          var result = Snapshot.docs.first;
          if(result.data()['Password']==_PassController.text.trim()){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Admin Login Successfull", style: TextStyle(fontSize:24),)));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminHomepage()));
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter the correct Password", style: TextStyle(fontSize:24,color: Colors.redAccent),)));
          }
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter the correct Username", style: TextStyle(fontSize:24,color: Colors.redAccent),)));
        }
      });

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(50.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black,
              Color.fromARGB(255, 92, 46, 44),
            ]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFb4817e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _UserController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.verified_user_rounded),
                    filled: false,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an Username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _PassController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    filled: false,
                    fillColor: Colors.white,
                  ),
                  obscureText: _isObscure,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        print("Forgot Password Clicked!!");
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _adminLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xFFb4817e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'LOG IN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
