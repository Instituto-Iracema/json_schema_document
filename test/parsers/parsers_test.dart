import 'package:flutter_test/flutter_test.dart';

import 'package:json_schema_document/json_schema_document.dart';
import 'package:json_schema_document/parsers/parsers.dart';

final jsonExample = {
  "\$schema": "http://json-schema.org/draft-07/schema",
  "\$id": "http://example.com/example.json",
  "type": "object",
  "title": "The root schema",
  "description": "The root schema comprises the entire JSON document.",
  "default": {},
  "examples": [
    {"id": 1, "name": "Ringo", "age": 16}
  ],
  "required": ["id", "name", "age"],
  "properties": {
    "id": {
      "\$id": "#/properties/id",
      "type": "integer",
      "title": "The id schema",
      "description": "An explanation about the purpose of this instance.",
      "default": 0,
      "examples": [1]
    },
    "name": {
      "\$id": "#/properties/name",
      "type": "string",
      "title": "The name schema",
      "description": "An explanation about the purpose of this instance.",
      "default": "",
      "examples": ["Ringo"]
    },
    "age": {
      "\$id": "#/properties/age",
      "type": "integer",
      "title": "The age schema",
      "description": "An explanation about the purpose of this instance.",
      "default": 0,
      "examples": [16]
    }
  },
  "additionalProperties": true
};

void main() {
  /// Tests if properties are correctly parsed with parseProperties function.
  test('Tests if properties are correctly parsed with parseProperties function',
      () {
    final properties = parseProperties(jsonExample);
    expect(properties is Map<String, JsonSchema>, true);
  });

  test('Tests if there is the expected "name" property', () {
    final properties = parseProperties(jsonExample);
    expect(properties['name'] != null, true);
  });

  test('Tests empty map returns when propertie is not of type jsonSchema', () {
    final badExample = jsonExample;
    badExample['properties'] = {
      1: 'String',
      2: 'String',
    };
    final properties = parseProperties(badExample);
    expect(properties.isEmpty, true);
  });
}
