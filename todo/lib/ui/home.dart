import 'package:flutter/material.dart';

import 'notodo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: new NoToDoScreen(),
    );
  }
}
