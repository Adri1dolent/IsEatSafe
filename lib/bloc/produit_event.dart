part of 'produit_bloc.dart';

abstract class ProduitEvent extends Equatable {
  const ProduitEvent();
}

class ProduitFetched extends ProduitEvent{
  @override
  List<Object?> get props => [];
}


class ProduitRefreshed extends ProduitEvent{
  @override
  List<Object?> get props => [];
}