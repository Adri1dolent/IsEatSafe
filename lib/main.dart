import 'package:flutter/material.dart';
import 'package:is_eat_safe/rappel_listview.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IsEatSafe'),
        ),
        body: Stack(
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
                child: const MaterialApp(

              ),
            ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange,
          fixedColor: Colors.white,
          currentIndex: _index,
          onTap: (int index) {
            setState(() {
              _index = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "list",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_alarm_outlined),
                label: "watchlist"
            )
          ],
        ),
      ),
    );
  }
}
