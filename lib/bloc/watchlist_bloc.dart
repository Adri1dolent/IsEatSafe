import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:is_eat_safe/models/watchlist_item.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(WatchlistInitial()) {
    on<ElementToBeAdded>((event, emit) async{
      emit(await _mapToStateOnAdded(state, event.toBeAddedItemId));
    });
  }

  Future<WatchlistState> _mapToStateOnAdded(WatchlistState state, int toBeAddedItemId) async {
    try{
      var it = WatchlistItem(toBeAddedItemId, "nomProduit", "image");
      if(state is WatchlistInitial){
        List<WatchlistItem> l = [];
        l.add(it);
        return WatchlistFilled(wlItems: l);
      }

      state as WatchlistFilled;
      return state.copyWith(wlItems: List.of(state.wlItems)..add(it));
    }catch (e){
      print(e.toString());
      return WatchlistError();
    }
  }
}
