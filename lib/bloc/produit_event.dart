part of 'produit_bloc.dart';

abstract class ProduitEvent extends Equatable {
  const ProduitEvent();

  @override
  List<Object?> get props => [];
}

class ProduitFetched extends ProduitEvent{
}


class ProduitRefreshed extends ProduitEvent{
}

class ProduitSearched extends ProduitEvent{

  final String search;

  const ProduitSearched(this.search);
}