import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:is_eat_safe/api_utils.dart';
import 'package:is_eat_safe/models/watchlist_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'watchlist_event.dart';

part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  SharedPreferences prefs;

  WatchlistBloc(this.prefs, List<WatchlistItem> wl)
      : super(
            (wl.isEmpty) ? WatchlistInitial() : WatchlistFilled(wlItems: wl)) {
    on<ElementToBeAdded>((event, emit) async {
      var tmp = await _mapToStateOnAdded(state, event.toBeAddedItemId);
      _saveWatchlistToSharedPreferences(tmp);
      emit(tmp);
    });

    on<ElementToBeDeleted>((event, emit) async {
      var tmp = await _getStateAfterDeletion(state, event.toBeDeletedItem);
      _saveWatchlistToSharedPreferences(tmp);
      emit(tmp);
    });

    on<WatchlistDeleted>((event, emit) async{
      var tmp = await _getInitialAfterListDeleted();
      _saveWatchlistToSharedPreferences(tmp);
      emit(tmp);
    });

    on<CheckForRecalledItems>((event, emit) async{
      emit(await _updateItemsRecalledState(state));
    });
  }

  Future<WatchlistState> _mapToStateOnAdded(
      WatchlistState state, String toBeAddedItemId) async {
    try {
      var it = await ApiUtils.fetchWLItem(toBeAddedItemId);

      if (state is WatchlistInitial) {
        var tmp = <WatchlistItem>[];
        tmp.add(it);
        return WatchlistFilled(wlItems: tmp);
      }

      state as WatchlistFilled;
      //Cant add same element twice
      if (state.wlItems.any((element) => element.id == toBeAddedItemId)) {
        return state;
      }
      return state.copyWith(wlItems: List.of(state.wlItems)..add(it));
    } catch (_) {
      return WatchlistError();
    }
  }

  Future<WatchlistState> _getStateAfterDeletion(WatchlistState state, WatchlistItem toBeDeletedItem) async {
    state as WatchlistFilled;
    List<WatchlistItem> res = List.from(state.wlItems);
    res.remove(toBeDeletedItem);
    if (res.isEmpty) {
      return WatchlistInitial();
    }
    return state.copyWith(wlItems: res);
  }

  //On all items deleted from watchlist
  Future<WatchlistState> _getInitialAfterListDeleted() async {
    return WatchlistInitial();
  }

  //Saves items to cache, gets them back on app relaunched
  Future<void> _saveWatchlistToSharedPreferences(WatchlistState state) async {
    if (state is WatchlistInitial) {
      await prefs.remove('watchlist_items');
      return;
    }
    state as WatchlistFilled;
    await prefs.setStringList(
        'watchlist_items', List.of(state.wlItems.map((e) => e.id)));
  }

  Future<WatchlistState> _updateItemsRecalledState(WatchlistState state) async {
    if(state is WatchlistInitial){
      return state;
    }

    state as WatchlistFilled;
    List<WatchlistItem> res = List.from(state.wlItems);
    for (var element in res) {
      element.isRecalled = await ApiUtils.isItemRecalled(element.id);
    }

    return state.copyWith(wlItems: res);
  }

}
