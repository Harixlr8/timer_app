import 'package:flutter/material.dart';
import 'package:timer_app/screens/savedtimers.dart';
import 'package:timer_app/screens/timerscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _text = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String passString = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const SavedList(),
                ),
              );
            },
            child: const Text(
              'View saved timings',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.amberAccent,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Stop Watch App',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username can\'t be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your username',
                  // errorText: _validate ? 'Username can\'t Be Empty' : null,
                ),
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            Container(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  passString = _text.text;
                  if (_formKey.currentState!.validate()) {
                    // print('validate and print');
                    // print(_text.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => TimerScreen(
                          name: passString,
                        ),
                      ),
                    );
                  }
                  _text.text = '';
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }
}
