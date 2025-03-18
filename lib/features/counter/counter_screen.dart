import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}
int count = 0;
class _CounterScreenState extends State<CounterScreen> {
  @override
  void initState() {
    print('Hello world');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 80.0,
        title: Text(
          'Counter App',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {

                });
                count--;
                print(count);
              },
              icon: Icon(
                Icons.remove,
                size: 50.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 100.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                setState(() {

                });
                count++;
                print(count);
              },
              icon: Icon(
                Icons.add,
                size: 50.0,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
