// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPriceCollection on Isar {
  IsarCollection<Price> get prices => this.collection();
}

const PriceSchema = CollectionSchema(
  name: r'Price',
  id: 7989864345434495037,
  properties: {
    r'graphType': PropertySchema(
      id: 0,
      name: r'graphType',
      type: IsarType.byte,
      enumMap: _PricegraphTypeEnumValueMap,
    ),
    r'price': PropertySchema(
      id: 1,
      name: r'price',
      type: IsarType.double,
    )
  },
  estimateSize: _priceEstimateSize,
  serialize: _priceSerialize,
  deserialize: _priceDeserialize,
  deserializeProp: _priceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _priceGetId,
  getLinks: _priceGetLinks,
  attach: _priceAttach,
  version: '3.0.0',
);

int _priceEstimateSize(
  Price object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _priceSerialize(
  Price object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.graphType.index);
  writer.writeDouble(offsets[1], object.price);
}

Price _priceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Price();
  object.graphType =
      _PricegraphTypeValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          GraphType.gas;
  object.id = id;
  object.price = reader.readDouble(offsets[1]);
  return object;
}

P _priceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_PricegraphTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          GraphType.gas) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PricegraphTypeEnumValueMap = {
  'gas': 0,
  'electricity': 1,
  'electricityDouble': 2,
  'water': 3,
  'firePlace': 4,
  'custom': 5,
};
const _PricegraphTypeValueEnumMap = {
  0: GraphType.gas,
  1: GraphType.electricity,
  2: GraphType.electricityDouble,
  3: GraphType.water,
  4: GraphType.firePlace,
  5: GraphType.custom,
};

Id _priceGetId(Price object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _priceGetLinks(Price object) {
  return [];
}

void _priceAttach(IsarCollection<dynamic> col, Id id, Price object) {
  object.id = id;
}

extension PriceQueryWhereSort on QueryBuilder<Price, Price, QWhere> {
  QueryBuilder<Price, Price, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PriceQueryWhere on QueryBuilder<Price, Price, QWhereClause> {
  QueryBuilder<Price, Price, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Price, Price, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Price, Price, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Price, Price, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PriceQueryFilter on QueryBuilder<Price, Price, QFilterCondition> {
  QueryBuilder<Price, Price, QAfterFilterCondition> graphTypeEqualTo(
      GraphType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'graphType',
        value: value,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> graphTypeGreaterThan(
    GraphType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'graphType',
        value: value,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> graphTypeLessThan(
    GraphType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'graphType',
        value: value,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> graphTypeBetween(
    GraphType lower,
    GraphType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'graphType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Price, Price, QAfterFilterCondition> priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PriceQueryObject on QueryBuilder<Price, Price, QFilterCondition> {}

extension PriceQueryLinks on QueryBuilder<Price, Price, QFilterCondition> {}

extension PriceQuerySortBy on QueryBuilder<Price, Price, QSortBy> {
  QueryBuilder<Price, Price, QAfterSortBy> sortByGraphType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graphType', Sort.asc);
    });
  }

  QueryBuilder<Price, Price, QAfterSortBy> sortByGraphTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graphType', Sort.desc);
    });
  }

  QueryBuilder<Price, Price, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<Price, Price, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }
}

extension PriceQuerySortThenBy on QueryBuilder<Price, Price, QSortThenBy> {
  QueryBuilder<Price, Price, QAfterSortBy> thenByGraphType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graphType', Sort.asc);
    });
  }

  QueryBuilder<Price, Price, QAfterSortBy> thenByGraphTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graphType', Sort.desc);
    });
  }

  QueryBuilder<Price, Price, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Price, Price, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Price, Price, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<Price, Price, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }
}

extension PriceQueryWhereDistinct on QueryBuilder<Price, Price, QDistinct> {
  QueryBuilder<Price, Price, QDistinct> distinctByGraphType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'graphType');
    });
  }

  QueryBuilder<Price, Price, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }
}

extension PriceQueryProperty on QueryBuilder<Price, Price, QQueryProperty> {
  QueryBuilder<Price, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Price, GraphType, QQueryOperations> graphTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'graphType');
    });
  }

  QueryBuilder<Price, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }
}
