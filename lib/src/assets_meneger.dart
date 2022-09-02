class Assets {
  static String icon(String name, {String? format}) {
    String png = ".png";
    return "assets/icons/$name" + (format ?? png);
  }
}
