import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:is_eat_safe/bloc/watchlist_bloc.dart';
import 'package:is_eat_safe/views/rappel_listview.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:is_eat_safe/views/watchlist_view.dart';

import 'bloc/produit_bloc.dart';

final watchlistBloc = WatchlistBloc();

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
                  child: BlocProvider<ProduitBloc>(
                      create: (context) => ProduitBloc()..add(ProduitFetched()),
                      child: const RappelListView()),
                ),
              ),
              Offstage(
                offstage: _index != 1,
                child: TickerMode(
                  enabled: _index == 1,
                  child: BlocProvider<WatchlistBloc>(
                      create: (context) => watchlistBloc,
                      child: const WatchListView()),
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
                  //TODO Detailled view of the scanned product
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
                onPressed: () async {
                  //TODO Add scanned product to watchlist bloc
                  var result = await BarcodeScanner.scan();
                  int codebar = int.parse(result.rawContent);
                  watchlistBloc.add(ElementToBeAdded(codebar));
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
