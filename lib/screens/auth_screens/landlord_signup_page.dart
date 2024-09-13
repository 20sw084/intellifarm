import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../auth_service.dart';
import 'landlord_login_page.dart';

class LandlordSignUpPage extends StatefulWidget {
  const LandlordSignUpPage({super.key});

  @override
  State<LandlordSignUpPage> createState() => _LandlordSignUpPageState();
}

class _LandlordSignUpPageState extends State<LandlordSignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _cpassword = '';
  String _phonenum = '';

  AuthService authService = AuthService();

  signUp() async {
    final User? user = await authService.signUp(
      _email,
      _password,
      _phonenum,
    );
    if (user != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Registration Successful",
          ),
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Perform sign-in logic here, e.g., authenticate user
      // You can replace this with your authentication code
      log('Email: $_email');
      // print('Password: $_password');
      signUp();
      // Navigate to the next screen or perform other actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text('Landlord Sign-Up Page'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const SizedBox(
                  height: 26,
                ),
                TextFormField(
                  onChanged: (value) {
                    _email = value;
                  },
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: Color(0xff00c39c), width: 2)),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        size: 30,
                        color: Color(0xff00c39c),
                      ),
                      hintText: 'EMAIL',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14)),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  onChanged: (value) {
                    _phonenum = value;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xff00c39c), width: 2)),
                    prefixIcon: const Icon(
                      Icons.phone_android_sharp,
                      size: 30,
                      color: Color(0xff00c39c),
                    ),
                    hintText: 'PHONE NUMBER',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  onChanged: (value) {
                    _password = value;
                  },
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: Color(0xff00c39c), width: 2)),
                      prefixIcon: const Icon(
                        Icons.password_outlined,
                        size: 30,
                        color: Color(0xff00c39c),
                      ),
                      hintText: 'PASSWORD',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14)),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  onChanged: (value) {
                    _cpassword = value;
                  },
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xff00c39c),
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.password,
                        size: 30,
                        color: Color(0xff00c39c),
                      ),
                      hintText: 'CONFIRM PASSWORD',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14)),
                ),
                const SizedBox(
                  height: 6,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: const Color(0xff00c39c),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00c39c),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      log(_password);
                      log(_cpassword);
                      if (_password == _cpassword) {
                        _submitForm();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Success"),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LandlordLoginPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Something went wrong"),
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'CREATE ACCOUNT',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600),
                  child: const Text(
                    'Already Have an Account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
