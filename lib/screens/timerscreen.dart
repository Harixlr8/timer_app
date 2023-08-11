import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_app/db/sql_helper.dart';
import 'package:timer_app/screens/savedtimers.dart';

class TimerScreen extends StatefulWidget {
  final String name;
  const TimerScreen({super.key, required this.name});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  List<Map<String, dynamic>> _journals = [];

  void loadData() async {
    final data = await SQLhelper.getItems();
    setState(() {
      _journals = data;
    });
  }

  Future<void> saveTime() async {
    await SQLhelper.createItem(widget.name, _result);
    loadData();
    print('Number of items.....${_journals.length}');
  }

  @override
  void initState() {
    super.initState();
    // loadData();
    // print('name Print');
    // print(widget.name);
  }

  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  // bool shouldProgress = false;

  String _result = '00:00:00';

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
        start = false;
      });
      // shouldProgress = true;
    });
    _stopwatch.start();
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
    // setState(() {
    //   start = true;
    // });
    setState(() {
      save = true;
      start = true;
    });
  }

  void _reset() {
    _stop();
    _stopwatch.reset();

    setState(() {
      _result = '00:00:00';

      //
      save = false;
      start = true;
    });
  }

  bool start = true;
  bool save = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (start) {
                Navigator.pop(context);
              } else {
                const snackBar = SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Stop timer to go back'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              ;
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
            ),
            onPressed: start == true && save == false ? null : _reset,
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.amberAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the result
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(250)),
              height: 220,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Center(
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 50.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            save == false
                ? Container(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        start == true ? _start() : _stop();
                      },
                      // onPressed: () => startOrStop(),
                      child: const Text(
                        'Start / Stop',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  )
                :
                // const SizedBox(
                //   height: 20,
                // ),
                Container(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        saveTime();
                        _reset();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const SavedList(),
                          ),
                        );
                        // if (shouldProgress) {
                        //   saveTime();
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (ctx) => const SavedList(),
                        //     ),
                        //   );
                        //   _reset();
                        // } else {
                        //   const snackBar = SnackBar(
                        //     duration: Duration(seconds: 1),
                        //     content: Text('Timer not started'),
                        //   );
                        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }
}
