import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/produit_bloc.dart';


class RappelListView extends StatefulWidget {
  const RappelListView({Key? key}) : super(key: key);

  @override
  State<RappelListView> createState() => _RappelListViewState();
}

class _RappelListViewState extends State<RappelListView> {

  final controller = ScrollController();

  late ProduitBloc _produitBloc;

  @override
  void initState() {
    super.initState();

    _produitBloc = BlocProvider.of(context);

    controller.addListener(() {
      if (controller.position.maxScrollExtent <= controller.offset + 300) {
        _produitBloc.add(ProduitFetched());
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProduitBloc, ProduitState>(
      builder: (context, state) {
        if (state is ProduitInitial) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if (state is ProduitLoaded) {
          if (state.produits.isEmpty) {
            return const Center(child: Text("no data"),);
          }
          return ListView.builder(
            controller: controller,
            itemCount: (state.hasReachedMax) ? state.produits.length : state
                .produits.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < state.produits.length) {
                final item = state.produits[index];

                return ListTile(
                  leading: Image.network(item.images.split(' ')[0],
                      height: 150, width: 100, fit: BoxFit.cover),
                  title: Text(item.nomProduit),
                );
              }
              else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        }
        else {
          return const Center(child: Text("erreur"),);
        }
      },
    );
  }
}
