// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_model.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const RelationSchema = Schema(
  name: r'Relation',
  id: 4898379945116015801,
  properties: {
    r'nodes': PropertySchema(
      id: 0,
      name: r'nodes',
      type: IsarType.objectList,
      target: r'GraphNode',
    ),
    r'xLabel': PropertySchema(
      id: 1,
      name: r'xLabel',
      type: IsarType.string,
    ),
    r'yLabel': PropertySchema(
      id: 2,
      name: r'yLabel',
      type: IsarType.string,
    )
  },
  estimateSize: _relationEstimateSize,
  serialize: _relationSerialize,
  deserialize: _relationDeserialize,
  deserializeProp: _relationDeserializeProp,
);

int _relationEstimateSize(
  Relation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nodes.length * 3;
  {
    final offsets = allOffsets[GraphNode]!;
    for (var i = 0; i < object.nodes.length; i++) {
      final value = object.nodes[i];
      bytesCount += GraphNodeSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.xLabel.length * 3;
  bytesCount += 3 + object.yLabel.length * 3;
  return bytesCount;
}

void _relationSerialize(
  Relation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<GraphNode>(
    offsets[0],
    allOffsets,
    GraphNodeSchema.serialize,
    object.nodes,
  );
  writer.writeString(offsets[1], object.xLabel);
  writer.writeString(offsets[2], object.yLabel);
}

Relation _relationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Relation();
  object.nodes = reader.readObjectList<GraphNode>(
        offsets[0],
        GraphNodeSchema.deserialize,
        allOffsets,
        GraphNode(),
      ) ??
      [];
  object.xLabel = reader.readString(offsets[1]);
  object.yLabel = reader.readString(offsets[2]);
  return object;
}

P _relationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<GraphNode>(
            offset,
            GraphNodeSchema.deserialize,
            allOffsets,
            GraphNode(),
          ) ??
          []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RelationQueryFilter
    on QueryBuilder<Relation, Relation, QFilterCondition> {
  QueryBuilder<Relation, Relation, QAfterFilterCondition> nodesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> nodesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> nodesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> nodesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition>
      nodesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> nodesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'xLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'xLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'xLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'xLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'xLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'xLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'xLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> xLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'xLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'yLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'yLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'yLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'yLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<Relation, Relation, QAfterFilterCondition> yLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'yLabel',
        value: '',
      ));
    });
  }
}

extension RelationQueryObject
    on QueryBuilder<Relation, Relation, QFilterCondition> {
  QueryBuilder<Relation, Relation, QAfterFilterCondition> nodesElement(
      FilterQuery<GraphNode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'nodes');
    });
  }
}
