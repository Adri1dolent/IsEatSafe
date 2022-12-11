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
        builder: (context, state) {
          print("rebuild");
      if (state is WatchlistInitial) {
        return const Center(
          child: Text(
              "To add an item to your watchlist press the \"+\" sign  below"),
        );
      }

      if (state is WatchlistFilled) {
        return Container(
          child: Column(
            children: [
              TextButton(onPressed: (){
                _watchlistBloc.add(WatchlistDeleted());
              },
                  child: const Text("Delete all items")),
              ListView.builder(
                scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: state.wlItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = state.wlItems[index];

                    return ListTile(
                      leading: Text(item.image),
                      title: Text(item.id.toString()),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete_forever),
                          onPressed: () {
                            _watchlistBloc.add(ElementToBeDeleted(item));
                          }),
                    );
                  }),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text("erreur"),
        );
      }
    });
  }
}
