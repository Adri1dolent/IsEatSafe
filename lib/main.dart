import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:is_eat_safe/BackgroundTasks/background_tasks_utils.dart';
import 'package:is_eat_safe/Notifications/custom_notifications.dart';
import 'package:is_eat_safe/api_utils.dart';
import 'package:is_eat_safe/bloc/watchlist_bloc.dart';
import 'package:is_eat_safe/models/watchlist_item.dart';
import 'package:is_eat_safe/views/detailled_product_view.dart';
import 'package:is_eat_safe/views/rappel_listview.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:is_eat_safe/views/watchlist_view.dart';
import 'package:is_eat_safe/widgets/popup_product_is_safe.dart';
import 'package:is_eat_safe/widgets/search_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

import 'bloc/produit_bloc.dart';

late WatchlistBloc _watchlistBloc;

late ProduitBloc _produitBloc;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Get saved watchlist items id and convered them in fully exploitable WatchlistItem objetcs
  final prefs = await SharedPreferences.getInstance();
  final List<String> items = prefs.getStringList('watchlist_items') ?? [];
  List<WatchlistItem> tmp = [];
  for (var e in items) {
    tmp.add(await ApiUtils.fetchWLItem(e));
  }

  //Instanciate blocs for use in multiple widgets and views
  _watchlistBloc = WatchlistBloc(prefs, tmp);
  _produitBloc = ProduitBloc();

  runApp( MaterialApp(
    title: 'IsEatSafe',
    theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'mavenpro'),
    debugShowCheckedModeBanner: false,
    home: const MyApp(),));


  //Fetch data from api and compares it to local data, if data matches emit local notification
  //See https://pub.dev/packages/background_fetch for more info
  if(Platform.isAndroid) {
    BackgroundFetch.registerHeadlessTask(BackgroundUtils.backgroundFetchHeadlessTask);
  }
  CustomNotifications.initialize(flutterLocalNotificationsPlugin);
  BackgroundUtils.configureBackgroundFetch(prefs, flutterLocalNotificationsPlugin);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;
  bool _searchBoolean = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: _searchBoolean && _index == 0 ? SearchTextfield(produitBloc: _produitBloc,) : const Text(
            'IsEatSafe', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          //add
          if (_index == 0)
            !_searchBoolean
                ? IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _searchBoolean = true;
                  });
                })
                : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _produitBloc.add(ProduitRefreshed());
                    _searchBoolean = false;
                  });
                }),
        ],
        toolbarHeight: 40,
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _index != 0,
            child: TickerMode(
              enabled: _index == 0,
              child: BlocProvider<ProduitBloc>(
                  create: (context) => _produitBloc..add(ProduitFetched()),
                  child: const RappelListView()),
            ),
          ),
          Offstage(
            offstage: _index != 1,
            child: TickerMode(
              enabled: _index == 1,
              child: BlocProvider<WatchlistBloc>(
                  create: (context) => _watchlistBloc,
                  child: const WatchListView()),
            ),
          ),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          //Scan to get detailled view of recalled product or dialog saying its not recalled
          var result = await BarcodeScanner.scan();
          if(result.type != ResultType.Barcode || result.format != BarcodeFormat.ean13){
            return;
          }
          if (await ApiUtils.isItemRecalled(result.rawContent)) {
            ApiUtils.getOneRecalledProduct(result.rawContent).then((value) =>
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DetailledProductView(value))));
          } else {
            showDialog(
              context: context,
              builder: (_) => const PopUpOk(),
              barrierDismissible: true,
            );
          }
        },
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
        ),
      )
          : FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          //Scan to add an item to the watchlist
          var result = await BarcodeScanner.scan();
          if(result.type != ResultType.Barcode || result.format != BarcodeFormat.ean13){
            return;
          }
          _watchlistBloc.add(ElementToBeAdded(result.rawContent));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
          backgroundColor: Theme
              .of(context)
              .primaryColor
              .withAlpha(0),
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
    );
  }

}

