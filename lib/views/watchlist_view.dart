import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:is_eat_safe/bloc/watchlist_bloc.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({Key? key}) : super(key: key);

  @override
  State<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends State<WatchListView> {

  late WatchlistBloc _watchlistBloc;

  @override
  void initState() {
    super.initState();

    _watchlistBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state){
          if (state is WatchlistInitial) {
            return const Center(child:Text("To add an item to your watchlist press the \"+\" sign  below"),);
          }

          if (state is WatchlistFilled) {
            if (state.wlItems.isEmpty) {
              return const Center(child: Text("no data"),);
            }
            return ListView.builder(
              itemCount: state.wlItems.length,
              itemBuilder: (BuildContext context, int index) {
                  final item = state.wlItems[index];

                  return ListTile(
                    leading: Text(item.image),
                    title: Text(item.id.toString()),
                  );
                }
            );
          }
          else {
            return const Center(child: Text("erreur"),);
          }
        }
    );
  }
}
