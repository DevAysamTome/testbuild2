// import 'package:flutter/material.dart';
// import 'package:user_app/views/signup_views/phoneOTP.dart';
// import ''; // تأكد من استيراد صفحة التحقق من OTP

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? _firstName;
//   String? _lastName;
//   String? _email;
//   String? _password;
//   String? _confirmPassword;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(221, 20, 22, 36),
//       body: SafeArea(
//         maintainBottomViewPadding: false,
//         child: Column(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/icons/bg.png"),
//                   fit: BoxFit.cover,
//                   opacity: 1,
//                 ),
//               ),
//               padding: const EdgeInsets.all(12),
//               alignment: Alignment.center,
//               height: MediaQuery.of(context).size.height * 0.30,
//               child: const Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "إنشاء حساب",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 38,
//                         fontFamily: "Elmassry",
//                         fontWeight: FontWeight.bold,
//                         shadows: [
//                           Shadow(
//                             offset: Offset(0.0, 5.0),
//                             blurRadius: 3.0,
//                             color: Color.fromARGB(255, 0, 0, 0),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       "سجّل حسابك الجديد للتمتع بالخدمات",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontFamily: "Elmassry",
//                         shadows: [
//                           Shadow(
//                             offset: Offset(0.0, 5.0),
//                             blurRadius: 3.0,
//                             color: Color.fromARGB(255, 0, 0, 0),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.white,
//                       offset: Offset(5.0, 10.0),
//                       blurRadius: 10.0,
//                       spreadRadius: 0.1,
//                     ),
//                   ],
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                 ),
//                 width: MediaQuery.of(context).size.width,
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: <Widget>[
//                         const SizedBox(height: 40),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Directionality(
//                             textDirection: TextDirection.rtl,
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: Colors.grey[200],
//                                 labelText: 'الاسم الأول',
//                                 hintText: 'جون',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 15, horizontal: 20),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال الاسم الأول';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _firstName = value;
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Directionality(
//                             textDirection: TextDirection.rtl,
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: Colors.grey[200],
//                                 labelText: 'اسم العائلة',
//                                 hintText: 'دي',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 15, horizontal: 20),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال اسم العائلة';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _lastName = value;
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Directionality(
//                             textDirection: TextDirection.rtl,
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: Colors.grey[200],
//                                 labelText: 'البريد الإلكتروني',
//                                 hintText: 'example@gmail.com',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 15, horizontal: 20),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال البريد الإلكتروني';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _email = value;
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Directionality(
//                             textDirection: TextDirection.rtl,
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: Colors.grey[200],
//                                 labelText: 'كلمة المرور',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 15, horizontal: 20),
//                                 suffixIcon: const Icon(Icons.visibility),
//                               ),
//                               obscureText: true,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال كلمة المرور';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _password = value;
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Directionality(
//                             textDirection: TextDirection.rtl,
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: Colors.grey[200],
//                                 labelText: 'تأكيد كلمة المرور',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 15, horizontal: 20),
//                                 suffixIcon: const Icon(Icons.visibility),
//                               ),
//                               obscureText: true,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى تأكيد كلمة المرور';
//                                 }
//                                 if (value != _password) {
//                                   return 'كلمات المرور غير متطابقة';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _confirmPassword = value;
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         Container(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 _formKey.currentState!.save();
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => PhoneOTPVerification(
//                                       fullname: '$_firstName $_lastName',
//                                       email: _email!,
//                                       password: _password!,
//                                       address: '',
//                                       dateOfBirth: '',
//                                       gender: '',
//                                     ),
//                                   ),
//                                 );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 16.0),
//                             ),
//                             child: const Text('التالي',
//                                 style: TextStyle(fontSize: 16)),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text(
//                                 'تسجيل الدخول',
//                                 style: TextStyle(color: Colors.orange),
//                               ),
//                             ),
//                             const Text(
//                               "لديك حساب بالفعل؟ ",
//                               style: TextStyle(color: Colors.black),
//                               textDirection: TextDirection.rtl,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'أو',
//                           style: TextStyle(color: Colors.black),
//                           textDirection: TextDirection.rtl,
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             IconButton(
//                               onPressed: () {
//                                 // handle Facebook login
//                               },
//                               icon: Image.asset(
//                                 'assets/icons/facebook.png',
//                                 height: 40,
//                                 width: 40,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 // handle Apple login
//                               },
//                               icon: Image.asset(
//                                 'assets/icons/google.png',
//                                 height: 40,
//                                 width: 40,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 50),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
