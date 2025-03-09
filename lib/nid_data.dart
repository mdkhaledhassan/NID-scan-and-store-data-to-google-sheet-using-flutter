class NIDData {
  static String nid(String text) {
    RegExp regex = RegExp(r'\b\d{10,17}\b');
    Match? match = regex.firstMatch(text);
    return match?.group(0) ?? "Not Found";
  }

  static String dob(String text) {
    RegExp regex = RegExp(
      r'\b(\d{2})[-/ ]?(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[-/ ]?(\d{4})\b'
      r'|\b(\d{2})[-/ ](\d{2})[-/ ](\d{4})\b'
      r'|\b(\d{4})[-/ ](\d{2})[-/ ](\d{2})\b'
      r'|\b(\d{4})[-/ ]?(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[-/ ]?(\d{2})\b',
      caseSensitive: false,
    );

    Match? match = regex.firstMatch(text);
    if (match != null) {
      String formattedDate =
          match.group(1) != null
              ? '${match.group(1)} ${match.group(2)} ${match.group(3)}'
              : match.group(4) != null
              ? '${match.group(4)} ${match.group(5)} ${match.group(6)}'
              : match.group(7) != null
              ? '${match.group(9)} ${match.group(8)} ${match.group(7)}'
              : '${match.group(12)} ${match.group(11)} ${match.group(10)}';

      return formattedDate.replaceAll(RegExp(r'\s+'), ' ').trim();
    }
    return "Not Found";
  }

  static String name(String text) {
    RegExp regex = RegExp(r'(?<=Name:)(.*?)(?=\n|$)', unicode: true);
    Match? match = regex.firstMatch(text);
    return match?.group(0) ?? "Not Found";
  }
}
