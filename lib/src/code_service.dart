import 'dart:convert';

import 'package:aurum_country_code_picker/src/codes.dart';

abstract class CountryCodesService {
  static Future<Map<String, String>> loadCodes() async {
    Map<String, String> result = {};

    for (dynamic entry in countryCodes) {
      final String? country = entry['name'];
      final int? code =
          int.tryParse(entry['dial_code'].toString().substring(1));

      if (country != null && code != null) result[country] = '+$code';
    }

    return result;
  }

  static Map<String, String> search(String searchInput,
      {required Map<String, String> codes}) {
    Map<String, String> result = {};
    final bool searchingForCode =
        int.tryParse(searchInput) != null || searchInput[0] == '+';

    final names = codes.keys.toList();
    final dialCodes = codes.values.toList();

    if (searchingForCode) {
      for (int i = 0; i < dialCodes.length; i++) {
        final c = dialCodes[i];
        final searchTrim = searchInput.replaceAll('+', '');
        final cTrim = c.replaceAll('+', '');

        if (cTrim.startsWith(searchTrim)) {
          final country = names[i];
          result[country] = codes[country]!;
        }
      }

      return result;
    }

    for (String n in names) {
      if (n.toLowerCase().startsWith(searchInput)) {
        result[n] = codes[n]!;
      }
    }

    return result;
  }
}
