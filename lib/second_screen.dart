import 'package:flutter/material.dart';
import 'package:model_screen/widget/model_widget.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second Screen"),),
      body: const ModelWidget(
        src: 'volante.glb',
        shadowIntensity: 1,
        shadowSoftness: 1,
        )
    );
  }
}