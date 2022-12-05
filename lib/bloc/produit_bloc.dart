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
  }

  Future<ProduitState> _mapProduitToState(ProduitState state) async {
    List<Produit> produits;

    try {
      if (state is ProduitInitial) {
        produits = await ApiUtils.fetchPage(0);
        return ProduitLoaded(produits: produits);
      }

      ProduitLoaded produitLoaded = state as ProduitLoaded;
      produits = await ApiUtils.fetchPage(state.page);
      return produits.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(produits: state.produits + produits,page: produitLoaded.page + 1);
    } catch (_) {
      return ProduitError();
    }
  }
}
