# Fun with macros

Highly experimental implementations of some not-so-common potential macros applications.

## Run

Run with `dart --enable-experiments lib/main.dart`.

## Macros

### `@MacroState`

`@MacroState` will convert an annotated field to a listenable field.

```dart
class Example {
  @MacroState()
  int _counter = 0;
}

void main() {
  final example = Example();

  print(example.counter); // prints "0"

  example.counter$.listen(print);
  example.counter++; // the listener above is called, prints "1" 
}
```

### `@Traceable`

`@Traceable` will make a private method available in a public, traceable
form -- in this example, it'll log the start and end times of traced method.

Could be extended to log method calls, including passed in params, etc.
to error reporting services.

```dart
class Example {
  @Traceable()
  void _testedMethod() {
    // ...
  }
}

void main() {
  final example = Example();
  example.testedMethod(); /*
    prints: "[TIMESTAMP] _testedMethod start"
            "[TIMESTAMP] _testedMethod stop"
  */
}
```
