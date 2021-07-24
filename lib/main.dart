import 'package:flutter/material.dart';
import 'package:flutter_starter/services/sampleService.dart';
import 'package:flutter_starter/utils/httpResponse.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  // const Home({Key? key}) : super(key: key);

  SampleService sampleService = SampleService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: TextButton(
              child: Text('Click'),
              onPressed: () async {
                HttpResponse? response = await sampleService.get();
              },
            ),
          ),
        ),
      ),
    );
  }
}
