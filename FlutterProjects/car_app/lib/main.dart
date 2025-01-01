import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(

  home: Home()
  ));
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My First Fire Application'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('hello'),
            ElevatedButton(
              onPressed: () {},
              child: Text('test')
            ),
            Container(
              color: Colors.cyan,
              padding: EdgeInsets.all(30.0),
              child : Text('Inside Container'),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Text('Click'),
          backgroundColor: Colors.grey,
        )
    );
  }
}



