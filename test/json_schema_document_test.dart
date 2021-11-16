import 'package:flutter_test/flutter_test.dart';

import 'package:json_schema_document/json_schema_document.dart';

void main() {
  test('Tests if constructor works with empty entry', () {
    JsonSchema jsonSchema = JsonSchema.fromMap({});
    expect(jsonSchema is JsonSchema, true);
  });
}
