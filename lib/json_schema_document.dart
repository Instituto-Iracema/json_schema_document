/// A library to handle JSON Schema Documents.
library json_schema_document;

import 'dart:convert' as convert;

/// An instance has one of six primitive types, and a range of possible values depending on the type:

/// - null:
/// A JSON "null" value (For the purposes of this library, we use 'nil' instead of 'null').
///
/// - boolean:
/// A "true" or "false" value, from the JSON "true" or "false" value
///
/// - object:
/// An unordered set of properties mapping a string to an instance, from the JSON "object" value
///
/// - array:
/// An ordered list of instances, from the JSON "array" value
///
/// - number:
/// An arbitrary-precision, base-10 decimal number value, from the JSON "number" value
///
/// - string:
/// A string of Unicode code points, from the JSON "string" value
enum JsonSchemaType {
  /// null:
  /// A JSON "null" value (For the purposes of this library, we use 'nil' instead of 'null').
  nil,

  /// boolean:
  /// A "true" or "false" value, from the JSON "true" or "false" value
  boolean,

  /// object:
  /// An unordered set of properties mapping a string to an instance, from the JSON "object" value
  object,

  /// array:
  /// An ordered list of instances, from the JSON "array" value
  array,

  /// number:
  /// An arbitrary-precision, base-10 decimal number value, from the JSON "number" value
  number,

  /// string:
  /// A string of Unicode code points, from the JSON "string" value
  string,

  /// SPECIAL_CASE_NONE:
  /// A special case for when the type is not defined.
  none,
}

/// A JsonSchemaDocument.
class JsonSchema {
  /// Given a Map in conformance with the JSON Schema Spec of a JSON Schema Document, \
  ///  this constructor will parse it and return a JsonSchema instance.
  JsonSchema.fromMap(Map<String, dynamic> map)
      : type = stringToJsonSchemaType[map['type']] ?? JsonSchemaType.none,
        annotations = {},
        title = map['title'],
        description = map['description'],
        required = map['required'] is List
            ? (map['required'] as List).whereType<String>().toList()
            : List.empty(),
        userInterface = map['userInterface'] ?? {},
        readOnly = map['readOnly'] ?? false,
        writeOnly = map['writeOnly'] ?? false,
        enum_ = map['enum'] ?? [],
        _source = map,
        properties = map['properties'] is Map<String, dynamic>
            ? (map['properties'] as Map<String, dynamic>)
                .map<String, JsonSchema>(
                (key, value) => MapEntry(
                  key,
                  JsonSchema.fromMap(
                    value,
                  ),
                ),
              )
            : {};

  /// A descriptive title of the element.
  String? title;

  /// A long description of the element. Used in hover menus and suggestions.
  String? description;

  /// #### According to the JSON Schema specification:

  /// The value of "properties" MUST be an object. Each value of this object MUST be a valid JSON Schema. \

  /// Validation succeeds if, for each name that appears in both the instance and as a name within this keyword's value, \
  /// the child instance for that name successfully validates against the corresponding schema. \

  /// The annotation result of this keyword is the set of instance property names matched by this keyword.\

  /// Omitting this keyword has the same assertion behavior as an empty object.
  Map<String, JsonSchema> properties;

  /// Useful metadata about the schema's context.
  Map<String, dynamic> annotations;

  /// The value of this keyword MUST be either a string or an array. If it is an array, elements of the array MUST be strings and MUST be unique.
  ///
  /// String values MUST be one of the six primitive types ("null", "boolean", "object", "array", "number", or "string"), or "integer" which matches any number with a zero fractional part.
  ///
  /// An instance validates if and only if the instance is in any of the sets listed for this keyword.
  JsonSchemaType type;

  /// ### 6.5.3. required
  ///
  /// The value of this keyword MUST be an array. Elements of this array, if any, MUST be strings, and MUST be unique. \
  ///
  /// An object instance is valid against this keyword if every item in the array is the name of a property in the instance. \
  ///
  /// Omitting this keyword has the same behavior as an empty array.
  List<String> required;

  // TODO: Add description
  Map<String, dynamic> userInterface;

  /// ### 6.1.2. enum
  /// The value of this keyword MUST be an array. This array SHOULD have at least one element. Elements in the array SHOULD be unique.
  ///
  /// An instance validates successfully against this keyword if its value is equal to one of the elements in this keyword's array value.
  ///
  /// Elements in the array might be of any type, including null.
  List<dynamic> enum_;

  /// ### 6.1.3. const
  /// The value of this keyword MAY be of any type, including null.
  ///
  /// Use of this keyword is functionally equivalent to an "enum" with a single value.
  ///
  /// An instance validates successfully against this keyword if its value is equal to the value of the keyword.
  dynamic const_;

  /// ### 9.4. "readOnly" and "writeOnly"

  /// The value of these keywords MUST be a boolean. When multiple occurrences \
  ///  of these keywords are applicable to a single sub-instance, the resulting \
  ///  behavior SHOULD be as for a true value if any occurrence specifies a true \
  ///  value, and SHOULD be as for a false value otherwise.
  ///
  /// If "readOnly" has a value of boolean true, it indicates that the value of \
  ///  the instance is managed exclusively by the owning authority, and attempts \
  ///  by an application to modify the value of this property are expected to be \
  ///  ignored or rejected by that owning authority.
  ///
  /// An instance document that is marked as "readOnly" for the entire document \
  ///  MAY be ignored if sent to the owning authority, or MAY result in an error, \
  ///  at the authority's discretion.
  ///
  /// If "writeOnly" has a value of boolean true, it indicates that the value  \
  /// is never present when the instance is retrieved from the owning authority. \
  ///  It can be present when sent to the owning authority to update or create  \
  /// the document (or the resource it represents), but it will not be included in \
  ///  any updated or newly created version of the instance.
  ///
  /// An instance document that is marked as "writeOnly" for the entire document \
  ///  MAY be returned as a blank document of some sort, or MAY produce an error \
  ///  upon retrieval, or have the retrieval request ignored, at the authority's \
  ///  discretion.
  ///
  /// For example, "readOnly" would be used to mark a database-generated serial \
  /// number as read-only, while "writeOnly" would be used to mark a password input field.
  ///
  /// These keywords can be used to assist in user interface instance generation. \
  ///  In particular, an application MAY choose to use a widget that hides input  \
  /// values as they are typed for write-only fields.
  ///
  /// Omitting these keywords has the same behavior as values of false.
  bool readOnly;

  /// ### 9.4. "readOnly" and "writeOnly"
  /// The value of these keywords MUST be a boolean. When multiple occurrences \
  ///  of these keywords are applicable to a single sub-instance, the resulting \
  ///  behavior SHOULD be as for a true value if any occurrence specifies a true \
  ///  value, and SHOULD be as for a false value otherwise.
  ///
  /// If "readOnly" has a value of boolean true, it indicates that the value of \
  ///  the instance is managed exclusively by the owning authority, and attempts \
  ///  by an application to modify the value of this property are expected to be \
  ///  ignored or rejected by that owning authority.
  ///
  /// An instance document that is marked as "readOnly" for the entire document \
  ///  MAY be ignored if sent to the owning authority, or MAY result in an error, \
  ///  at the authority's discretion.
  ///
  /// If "writeOnly" has a value of boolean true, it indicates that the value  \
  /// is never present when the instance is retrieved from the owning authority. \
  ///  It can be present when sent to the owning authority to update or create  \
  /// the document (or the resource it represents), but it will not be included in \
  ///  any updated or newly created version of the instance.
  ///
  /// An instance document that is marked as "writeOnly" for the entire document \
  ///  MAY be returned as a blank document of some sort, or MAY produce an error \
  ///  upon retrieval, or have the retrieval request ignored, at the authority's \
  ///  discretion.
  ///
  /// For example, "readOnly" would be used to mark a database-generated serial \
  /// number as read-only, while "writeOnly" would be used to mark a password input field.
  ///
  /// These keywords can be used to assist in user interface instance generation. \
  ///  In particular, an application MAY choose to use a widget that hides input  \
  /// values as they are typed for write-only fields.
  ///
  /// Omitting these keywords has the same behavior as values of false.
  bool writeOnly;

  Map<String, dynamic> _source;

  @override
  String toString() {
    convert.JsonEncoder encoder = const convert.JsonEncoder.withIndent('  ');
    return encoder.convert(_source);
  }
}

Map<String, JsonSchemaType> stringToJsonSchemaType = {
  'null': JsonSchemaType.nil,
  'boolean': JsonSchemaType.boolean,
  'object': JsonSchemaType.object,
  'array': JsonSchemaType.array,
  'number': JsonSchemaType.number,
  'string': JsonSchemaType.string,
  'none': JsonSchemaType.none,
};
