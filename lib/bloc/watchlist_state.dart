part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
}

class WatchlistFilled extends WatchlistState {

  const WatchlistFilled({
    this.wlItems = const <WatchlistItem>[],
  });

  final List<WatchlistItem> wlItems;

  WatchlistFilled copyWith({List<WatchlistItem>? wlItems}){
    return WatchlistFilled(
        wlItems: wlItems ?? this.wlItems,
    );
  }

  WatchlistFilled removeAndCopy(WatchlistItem i){
    var tmp = this.wlItems;
    tmp.remove(i);
    return WatchlistFilled(
      wlItems: tmp
    );
  }

  @override
  List<Object?> get props => [wlItems];
}

class WatchlistError extends WatchlistState{
}

