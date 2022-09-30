import 'package:flutter/material.dart';

class AddGraphPage extends StatefulWidget {
  const AddGraphPage({super.key});

  @override
  State<AddGraphPage> createState() => _AddGraphPageState();
}

class _AddGraphPageState extends State<AddGraphPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Graph",
        ),
      ),
    );
  }
}
