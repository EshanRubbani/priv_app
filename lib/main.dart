
import 'package:flutter/material.dart';
import 'package:priv_app/permisions.dart';



void main() async {
 
  runApp(const MaterialApp(home: MyApp()));

}




class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  
  Widget build(BuildContext context) {
  
    return MaterialApp(
      title: 'PRIVATE APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Permissions(),
    );
  }
}
