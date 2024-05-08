import 'package:flutter/material.dart';
import 'package:model_screen/second_screen.dart';
import './widget/model_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3d Model Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FirstScreen()
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("3D model rendering TEST"),),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height*0.9,
        child:ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.7,
            child: const ModelWidget(
              src: 'lancer.glb',
              shadowIntensity: 1,
              shadowSoftness: 1,
            )),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondScreen()));
          }, child: const Text("Go to SecondScreen"))
        ],
      ))
      );
  }
}
