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

The official country code picker from Tellurium by Quadren. Designed with our in-house Aurum design system.

## Features

1. Supports searching for country code.
2. Returns the country name and country code together.
3. Highly opinionated design with Quadren's Aurum design system.

## Usage

All you need to do is call the country code picker function.

```dart
final countryCode = await pickCountryCode(context);
```

That's it! Now you can access two paramters:

```dart
final String countryName = countryCode.country;
final String code = countryCode.code;
```

## Additional information

Please note that this package may see major or minor UI changes as our design system evolves and grows. 