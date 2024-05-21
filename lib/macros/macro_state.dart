import 'package:macros/macros.dart';

macro class MacroState implements FieldDeclarationsMacro {
  const MacroState();

  @override
  Future<void> buildDeclarationsForField(
    FieldDeclaration field,
    MemberDeclarationBuilder builder,
  ) async {
    final name = field.identifier.name;
    if (!name.startsWith('_')) {
      throw ArgumentError(
          '@observable can only annotate private fields, and it will create '
          'public getters and setters for them, but the public field '
          '$name was annotated.');
    }

    final streamController = await builder.resolveIdentifier(
      Uri.parse('dart:async'),
      'StreamController',
    );
    final stream = await builder.resolveIdentifier(
      Uri.parse('dart:async'),
      'Stream',
    );
    
    final publicName = name.substring(1);
    final controllerName = '${publicName}Controller';

    final controllerField = DeclarationCode.fromParts([
      'final $controllerName = ',
      streamController,
      '();',
    ]);
    builder.declareInType(controllerField);    
    
    final getters = DeclarationCode.fromParts([
      field.type.code,
      ' get $publicName => ',
      field.identifier,
      ';\n',
      stream,
      ' get $publicName\$ => $controllerName.stream;'
    ]);
    builder.declareInType(getters);

    final setter = DeclarationCode.fromParts([
      'set $publicName(',
      field.type.code,
      ' val) {\n',
      field.identifier,
      ' = val;\n',
      '$controllerName.add(val);\n'
      '}',
    ]);
    builder.declareInType(setter);
  }
}