part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
}

class WatchlistFilled extends WatchlistState {

  final List<WatchlistItem> wlItems;

  const WatchlistFilled({
    this.wlItems = const <WatchlistItem>[],
  });

  WatchlistFilled copyWith({List<WatchlistItem>? wlItems}){
    return WatchlistFilled(
        wlItems: wlItems ?? this.wlItems,
    );
  }

  WatchlistFilled removeAndCopy(WatchlistItem i){
    var tmp = wlItems;
    tmp.remove(i);
    return WatchlistFilled(
      wlItems: tmp
    );
  }

  @override
  List<Object?> get props => [this.wlItems];
}

class WatchlistError extends WatchlistState{
}

