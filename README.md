<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

<!-- TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them. -->
A library for handling JSON Schema Documents.

## Features

<!-- TODO: List what your package can do. Maybe include images, gifs, or videos. -->
- Easy handling of JSON Schema Documents.
- Friendly API
- UI optimized getters
- Growing ecosystem of low-coupling widgets that consumes this package

## Getting started

<!-- TODO: List prerequisites and provide or point to information on how to
start using the package. -->

## Usage

<!-- TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.  -->

```dart
JsonSchema jsonSchema = JsonSchema.fromMap({
  "\$schema": "http://json-schema.org/draft-07/schema",
  "\$id": "http://example.com/example.json",
  "type": "object",
  "title": "The root schema",
  "description": "The root schema comprises the entire JSON document.",
  "default": {},
  "examples": [
    {"name": "Ringo", "age": 16}
  ],
  "required": ["id", "name", "age"],
  "properties": {
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
});
```

## Additional information

<!-- TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more. -->
Learn more about JSON Schema at https://json-schema.org/
