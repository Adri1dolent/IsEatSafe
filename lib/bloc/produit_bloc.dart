import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:is_eat_safe/api_utils.dart';

import 'package:is_eat_safe/models/produit.dart';

part 'produit_event.dart';

part 'produit_state.dart';

class ProduitBloc extends Bloc<ProduitEvent, ProduitState> {
  ProduitBloc() : super(ProduitInitial()) {

    on<ProduitFetched>((event, emit) async {
      emit(await _mapProduitToState(state));
    });

    on<ProduitSearched>((event, emit) async{
      var produits = await ApiUtils.fetchPageByProductId(0, event.search);
      emit(ProduitLoaded(produits: produits,search: event.search, hasReachedMax: (produits.length<20)));
    });

    on<ProduitRefreshed>((event, emit) async {
      var produits = await ApiUtils.fetchPage(0);
      emit(ProduitLoaded(produits: produits));
    });

  }

  Future<ProduitState> _mapProduitToState(ProduitState state) async {
    List<Produit> produits;

    try {
      if (state is ProduitInitial) {
        produits = await ApiUtils.fetchPage(0);
        return ProduitLoaded(produits: produits);
      }

      ProduitLoaded produitLoaded = state as ProduitLoaded;
      produits = await ApiUtils.fetchPageByProductId(state.page, state.search);
      return produits.length < 20
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(produits: state.produits + produits,page: produitLoaded.page + 1);
    } catch (_) {
      return ProduitError();
    }
  }
}
