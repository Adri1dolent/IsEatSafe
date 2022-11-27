import 'package:flutter/material.dart';
import 'package:is_eat_safe/rappel_listview.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IsEatSafe',
      theme: ThemeData(primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: const Text('IsEatSafe'),
        ),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: <Widget>[
              Offstage(
                offstage: _index != 0,
                child: TickerMode(
                  enabled: _index == 0,
                  child: const RappelListView(),
                ),
              ),
              Offstage(
                offstage: _index != 1,
                child: TickerMode(
                  enabled: _index == 1,
                  child: const MaterialApp(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Offstage(
              offstage: _index != 0,
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () async {
                  var result = await BarcodeScanner.scan();
                },
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                ),
              ),
            ),
            Offstage(
              offstage: _index != 1,
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {

                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          elevation: 1,
          notchMargin: 5,
          color: Colors.orange,
          child: BottomNavigationBar(
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
            fixedColor: Colors.white,
            currentIndex: _index,
            onTap: (int index) {
              setState(() {
                _index = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                  child: Icon(Icons.list),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Icon(Icons.add_alarm_outlined),
                ),
                label: "",
              )
            ],
          ),
        ),
      ),
    );
  }
}
