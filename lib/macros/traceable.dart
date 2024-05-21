import 'package:macros/macros.dart';

macro class Traceable implements MethodDeclarationsMacro {
  const Traceable();

  @override
  Future<void> buildDeclarationsForMethod(
    MethodDeclaration method,
    MemberDeclarationBuilder builder,
  ) async {
    final name = method.identifier.name;
    if (!name.startsWith('_')) {
      throw ArgumentError(
          '@traceable can only annotate private methods, and it will create '
          'public, traceable method but $name was annotated.');
    }

    final publicName = name.substring(1);
    final print = builder.resolveIdentifier(Uri.parse('dart:core'), 'print');
    builder.declareInType(
      DeclarationCode.fromParts([
        'void ',
        '${publicName}() {\n',
        'print("[\${DateTime.now().microsecondsSinceEpoch}] ${name} start");\n',
        '$name();\n',
        'print("[\${DateTime.now().microsecondsSinceEpoch}] ${name} end");\n',
        '}',
      ]),
    );
  }
}