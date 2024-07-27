import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:user_app/models/cardProvider.dart';
import 'package:user_app/models/cartProvider.dart';
import 'package:user_app/views/weclome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBIY3TUh1CMt72v-LbLYY7RACHISkY_MlA",
            appId: "1:572219831254:web:eb578252ef66715545ea77",
            messagingSenderId: "572219831254",
            projectId: "sarie-46b77"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CreditCardProvider())
        // يمكنك إضافة مزودي الخدمة الآخرين هنا
      ],
      child: MaterialApp(
        title: 'Sarie App',
        theme: ThemeData(fontFamily: 'Elmassry'),
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
