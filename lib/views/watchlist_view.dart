import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:is_eat_safe/bloc/watchlist_bloc.dart';
import 'package:collection/collection.dart';
import 'package:is_eat_safe/models/produit.dart';
import 'package:is_eat_safe/api_utils.dart';
import 'package:is_eat_safe/views/detailled_product_view.dart';

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
              if(state.wlItems.firstWhereOrNull((it) => it.isRecalled == true) != null) const Text("Votre list contient un/des produits rappelés"),
              TextButton(onPressed: (){
                _watchlistBloc.add(WatchlistDeleted());
              },
                  child: const Text("Delete all items")),
              ListView.builder(
                physics: const RangeMaintainingScrollPhysics(),
                scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: state.wlItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = state.wlItems[index];

                    return ListTile(
                      onTap: () => {
                        if(item.isRecalled){
                          ApiUtils.getOneRecalledProduct(item.id).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailledProductView(value))))
                        }
                      },
                      tileColor: item.isRecalled ? Colors.redAccent : Colors.white,
                      leading: Image.network(item.image),
                      title: Text(item.nomProduit),
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
