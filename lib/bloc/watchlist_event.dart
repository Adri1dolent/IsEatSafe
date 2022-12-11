part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class ElementToBeAdded extends WatchlistEvent{
  final String toBeAddedItemId;

  const ElementToBeAdded(this.toBeAddedItemId);
}

class ElementToBeDeleted extends WatchlistEvent{
  final WatchlistItem toBeDeletedItem;

  const ElementToBeDeleted(this.toBeDeletedItem);
}

class AllElementsToBeRemoved extends WatchlistEvent{
}

class WatchlistDeleted extends WatchlistEvent{
}

