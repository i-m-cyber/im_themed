# im_themed

Flutter library for changing ThemeData in runtime

## Features

- supports basic ThemeData parsing and encoding from/to JSON

## Getting started

### Installation

```bash
flutter pub add im_themed
```

Or add to your `pubspec.yaml`:

```yaml
dependencies:
  im_themed: <last_version>
```

## Usage

Checkout [example/lib/main.dart](example/lib/main.dart) for complete example.

```dart
void main() async {
  runApp(
    const ImThemedApp(
      app: SingleThemeApp(),
    ),
  );
}
```

## Acknowledgments

This library uses source code from the following projects:

- [csslib](https://pub.dev/packages/csslib)

## Additional information

Work in progress

## License

[LICENSE](LICENSE)
