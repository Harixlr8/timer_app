import 'package:flutter/material.dart';
import 'package:timer_app/screens/homescreen.dart';

import '../db/sql_helper.dart';

class SavedList extends StatefulWidget {
  const SavedList({super.key});

  @override
  State<SavedList> createState() => _SavedListState();
}

class _SavedListState extends State<SavedList> {
  List<Map<String, dynamic>> _journals = [];

  void loadData() async {
    final data = await SQLhelper.getItems();
    setState(() {
      _journals = data;
    });
  }

  // void clearData()async{
  //   await SQLhelper.clearTable();
  // }
  clearTable() async {
    final db = await SQLhelper.db();
    return await db.rawDelete("DELETE FROM items");
    // setState(() {
    //   initState();
    // });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          clearTable();
          setState(() {
            _journals = [];
          });
        },
        child: const Text('Clear all data'),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (ctx) => const HomeScreen()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(
          'List of Users and\ntheir Timings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.amberAccent,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                ),
                Text(
                  'Timings',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                )
              ],
            ),
            SizedBox(
              height: _journals.isEmpty ? 150 : 20,
            ),
            _journals.isEmpty
                ? const Text('No timings recorded',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400))
                : SizedBox(
                    height: size.height * 0.7,
                    width: size.width * 0.9,
                    child: ListView.builder(
                      itemCount: _journals.length,
                      itemBuilder: (context, index) => Table(
                        // defaultColumnWidth: FixedColumnWidth(130),
                        border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 0.7,
                        ),
                        children: [
                          TableRow(children: [
                            Column(children: [
                              Text(_journals[index]['name'],
                                  style: const TextStyle(fontSize: 22.0))
                            ]),
                            Column(children: [
                              Text(_journals[index]['time'],
                                  style: const TextStyle(fontSize: 22.0))
                            ]),
                          ])
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
