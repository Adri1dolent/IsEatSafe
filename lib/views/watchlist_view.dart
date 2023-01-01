import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:is_eat_safe/bloc/watchlist_bloc.dart';
import 'package:collection/collection.dart';
import 'package:is_eat_safe/widgets/watchlist_tile.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({Key? key}) : super(key: key);

  @override
  State<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends State<WatchListView> {
   late WatchlistBloc _watchlistBloc;

  @override
  void initState() {
    //WidgetsBinding.instance.addObserver(this);
    super.initState();
    _watchlistBloc = BlocProvider.of(context);
  }


   Future<void> refresh() async{
     _watchlistBloc.add(CheckForRecalledItems());
   }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
        if (state is WatchlistInitial) {
          return const Center(
            child: Text(
                "Pour ajouter un produit à cotre liste, cliquez sur le bouton \"+\" si dessous"),
          );
        }

        if (state is WatchlistFilled) {
          return Column(
            children: [
              if(state.wlItems.firstWhereOrNull((it) => it.isRecalled == true) != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.redAccent
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.warning_amber),
                          Text("Produit rappelé",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: TextButton(onPressed: (){
                  _watchlistBloc.add(WatchlistDeleted());
                },
                    child: const Text("Delete all items")),
              ),
              Flexible(
                child: ListView.builder(
                    itemCount: state.wlItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = state.wlItems[index];

                      return WatchlistTile(item: item, watchlistBloc: _watchlistBloc);
                    }),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text("erreur"),
          );
        }
      }),
    );
  }
}
