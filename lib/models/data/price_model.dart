import 'package:isar/isar.dart';
import 'package:walewein/models/data/graph_model.dart';

part 'price_model.g.dart';

@collection
class Price {
  Id? id;

  @enumerated
  late final GraphType graphType;

  double price = 0;

  Price();

  Price.from(this.graphType, this.price);
}

final defaultPrices = {
  /// Per m^3
  GraphType.gas: Price.from(GraphType.gas, 24),

  /// Per kWh
  GraphType.electricity: Price.from(GraphType.electricity, 55),

  /// Per kWh
  /// Use this value for night tariff
  GraphType.electricityDouble: Price.from(GraphType.electricity, 43),

  /// Per m^3
  GraphType.water: Price.from(GraphType.water, 50),

  /// Per kg
  GraphType.firePlace: Price.from(GraphType.firePlace, 0.6),
};
