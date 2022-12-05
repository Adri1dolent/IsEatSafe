part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class ElementToBeAdded extends WatchlistEvent{
  final int toBeAddedItemId;

  const ElementToBeAdded(this.toBeAddedItemId);
}

class AllElementsToBeRemoved extends WatchlistEvent{

}
