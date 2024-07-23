import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/views/home/home_component.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _phoneNumber;
  String? _smsCode;
  String? _verificationId;

  void handleSignIn(String phoneNumber) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        handleUser(userCredential.user);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل التحقق: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إرسال رمز التحقق')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void handleUser(User? user) async {
    if (user != null) {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'phoneNumber': user.phoneNumber,
          'role': 'user', // تعيين دور افتراضي
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeComponent()),
      );
    }
  }

  void verifyCode(String smsCode) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    handleUser(userCredential.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 20, 22, 36),
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icons/bg.png"),
                    fit: BoxFit.cover,
                    opacity: 1,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.30,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontFamily: "Elmassry",
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0.0, 5.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "تفضل سجّل دخولك برقم الهاتف",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Elmassry",
                        shadows: [
                          Shadow(
                            offset: Offset(0.0, 5.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(5.0, 10.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.1,
                      ),
                    ],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 40),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                labelText: 'رقم الهاتف',
                                hintText: 'مثال: +1234567890',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال رقم الهاتف';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _phoneNumber = value;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_verificationId != null) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  labelText: 'رمز التحقق',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال رمز التحقق';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _smsCode = value;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (_verificationId == null) {
                                    handleSignIn(_phoneNumber!);
                                  } else {
                                    verifyCode(_smsCode!);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                              ),
                              child: const Text('تسجيل الدخول',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          const Text(
                            'أو',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
