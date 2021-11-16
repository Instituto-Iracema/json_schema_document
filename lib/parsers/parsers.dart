import 'package:json_schema_document/json_schema_document.dart';

/// Parse the properties of a JSON schema.
Map<String, JsonSchema> parseProperties(Map<String, dynamic> jsonSchema) {
  final _properties = jsonSchema['properties'];
  if (_properties is Map<String, dynamic>) {
    return _properties
        .map((key, value) => MapEntry(key, JsonSchema.fromMap(value)));
  }
  return {};
}
