import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/examples/landingpage1.dart';
import 'package:untitled/provider/imagepathprovider.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> imagepathprovider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandingPage(),
      ),
    );
  }
}