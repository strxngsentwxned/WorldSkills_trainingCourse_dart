import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //open modal
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('fill in something'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        //close modal
                        Navigator.of(context).pop();
                      },
                      child: Text('ok'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Open Modal'),
        ),
      ),
    );
  }
}
