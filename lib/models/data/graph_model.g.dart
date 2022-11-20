// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetGraphCollection on Isar {
  IsarCollection<Graph> get graphs => this.collection();
}

const GraphSchema = CollectionSchema(
  name: r'Graph',
  id: 5111760996193448628,
  properties: {
    r'dateCreated': PropertySchema(
      id: 0,
      name: r'dateCreated',
      type: IsarType.dateTime,
    ),
    r'graphType': PropertySchema(
      id: 1,
      name: r'graphType',
      type: IsarType.byte,
      enumMap: _GraphgraphTypeEnumValueMap,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'relations': PropertySchema(
      id: 3,
      name: r'relations',
      type: IsarType.objectList,
      target: r'Relation',
    )
  },
  estimateSize: _graphEstimateSize,
  serialize: _graphSerialize,
  deserialize: _graphDeserialize,
  deserializeProp: _graphDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Relation': RelationSchema, r'GraphNode': GraphNodeSchema},
  getId: _graphGetId,
  getLinks: _graphGetLinks,
  attach: _graphAttach,
  version: '3.0.0',
);

int _graphEstimateSize(
  Graph object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.relations.length * 3;
  {
    final offsets = allOffsets[Relation]!;
    for (var i = 0; i < object.relations.length; i++) {
      final value = object.relations[i];
      bytesCount += RelationSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _graphSerialize(
  Graph object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateCreated);
  writer.writeByte(offsets[1], object.graphType.index);
  writer.writeString(offsets[2], object.name);
  writer.writeObjectList<Relation>(
    offsets[3],
    allOffsets,
    RelationSchema.serialize,
    object.relations,
  );
}

Graph _graphDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Graph();
  object.dateCreated = reader.readDateTime(offsets[0]);
  object.graphType =
      _GraphgraphTypeValueEnumMap[reader.readByteOrNull(offsets[1])] ??
          GraphType.gas;
  object.id = id;
  object.name = reader.readStringOrNull(offsets[2]);
  object.relations = reader.readObjectList<Relation>(
        offsets[3],
        RelationSchema.deserialize,
        allOffsets,
        Relation(),
      ) ??
      [];
  return object;
}

P _graphDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (_GraphgraphTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          GraphType.gas) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<Relation>(
            offset,
            RelationSchema.deserialize,
            allOffsets,
            Relation(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _GraphgraphTypeEnumValueMap = {
  'gas': 0,
  'electricity': 1,
  'electricityDouble': 2,
  'water': 3,
  'firePlace': 4,
};
const _GraphgraphTypeValueEnumMap = {
  0: GraphType.gas,
  1: GraphType.electricity,
  2: GraphType.electricityDouble,
  3: GraphType.water,
  4: GraphType.firePlace,
};

Id _graphGetId(Graph object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _graphGetLinks(Graph object) {
  return [];
}

void _graphAttach(IsarCollection<dynamic> col, Id id, Graph object) {
  object.id = id;
}

extension GraphQueryWhereSort on QueryBuilder<Graph, Graph, QWhere> {
  QueryBuilder<Graph, Graph, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GraphQueryWhere on QueryBuilder<Graph, Graph, QWhereClause> {
  QueryBuilder<Graph, Graph, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Graph, Graph, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Graph, Graph, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Graph, Graph, QAfterWhereClause> idBetween(
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

extension GraphQueryFilter on QueryBuilder<Graph, Graph, QFilterCondition> {
  QueryBuilder<Graph, Graph, QAfterFilterCondition> dateCreatedEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> dateCreatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> dateCreatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> dateCreatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCreated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> graphTypeEqualTo(
      GraphType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'graphType',
        value: value,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> graphTypeGreaterThan(
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

  QueryBuilder<Graph, Graph, QAfterFilterCondition> graphTypeLessThan(
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

  QueryBuilder<Graph, Graph, QAfterFilterCondition> graphTypeBetween(
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

  QueryBuilder<Graph, Graph, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Graph, Graph, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Graph, Graph, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> relationsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relations',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> relationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relations',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> relationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relations',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> relationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relations',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> relationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relations',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Graph, Graph, QAfterFilterCondition> relationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relations',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension GraphQueryObject on QueryBuilder<Graph, Graph, QFilterCondition> {
  QueryBuilder<Graph, Graph, QAfterFilterCondition> relationsElement(
      FilterQuery<Relation> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'relations');
    });
  }
}

extension GraphQueryLinks on QueryBuilder<Graph, Graph, QFilterCondition> {}

extension GraphQuerySortBy on QueryBuilder<Graph, Graph, QSortBy> {
  QueryBuilder<Graph, Graph, QAfterSortBy> sortByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> sortByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> sortByGraphType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graphType', Sort.asc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> sortByGraphTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graphType', Sort.desc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension GraphQuerySortThenBy on QueryBuilder<Graph, Graph, QSortThenBy> {
  QueryBuilder<Graph, Graph, QAfterSortBy> thenByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> thenByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> thenByGraphType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graphType', Sort.asc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> thenByGraphTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graphType', Sort.desc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Graph, Graph, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension GraphQueryWhereDistinct on QueryBuilder<Graph, Graph, QDistinct> {
  QueryBuilder<Graph, Graph, QDistinct> distinctByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCreated');
    });
  }

  QueryBuilder<Graph, Graph, QDistinct> distinctByGraphType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'graphType');
    });
  }

  QueryBuilder<Graph, Graph, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension GraphQueryProperty on QueryBuilder<Graph, Graph, QQueryProperty> {
  QueryBuilder<Graph, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Graph, DateTime, QQueryOperations> dateCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCreated');
    });
  }

  QueryBuilder<Graph, GraphType, QQueryOperations> graphTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'graphType');
    });
  }

  QueryBuilder<Graph, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Graph, List<Relation>, QQueryOperations> relationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relations');
    });
  }
}
