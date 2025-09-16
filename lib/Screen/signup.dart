import 'package:firebase_app/Data/database.dart';
import 'package:firebase_app/Data/shared.dart';
import 'package:firebase_app/Screen/home.dart';
import 'package:firebase_app/Screen/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //-------------- Variables ------------------//
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;

  //-------------- Dispose Method ------------------//
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  //-------------- SignUp Function ------------------//
  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {

  //-------------- Is Loading ------------------//
      setState(() {
        _isLoading = true;
      });

      //-------------- Sign up Success ------------------//
      try {
        //-------------- Authentication ------------------//
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
        print(userCredential.user?.uid);

        //-------------- Randomly Generated Id ------------------//
        String id = randomAlphaNumeric(10);

        //-------------- Locally Saving Data ------------------//
        await Shared().saveUserId(id);
        await Shared().saveUserName(_nameController.text.trim());
        await Shared().saveUserEmail(_emailController.text.trim());
        await Shared().saveUserImage("https://th.bing.com/th/id/OIP.oKuAQ4Z7v5FWK0JmqoMnUAHaHa?w=137&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3");

        //-------------- User Information Map ------------------//
        Map<String,dynamic> UserInfoMap = {
          "Name": _nameController.text.trim(),
          "Email": _emailController.text.trim(),
          "Id": id,
          "Image": "https://th.bing.com/th/id/OIP.oKuAQ4Z7v5FWK0JmqoMnUAHaHa?w=137&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3"
        };

        //-------------- Storing the Data in Firestore ------------------//
        await Database().addUserDetails(UserInfoMap, id);

        //-------------- Pop-Up message ------------------//
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Signup Successfull")));

        //-------------- Navigate to the HomePage ------------------//
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } 
      //-------------- Sign Up Error ------------------//
      on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message!)));
      }

      //-------------- Loading Ended ------------------//
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Color(0xFF2b1615),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFb4817e),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      hintText: "Enter your full name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter your name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your Email Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your mail";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "PassWord",
                      hintText: "Create a strong password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Create a Password";
                      }
                      if (value.length < 6) {
                        return "Password must be atleast 6 character long";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(0xFFb4817e),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    child: const Text(
                      "Already Have An Account? Login",
                      style: TextStyle(color: Color(0xFFb4817e)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
