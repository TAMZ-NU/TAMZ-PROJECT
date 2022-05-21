class Languages {
  final int id;
  final String name;
  final String languageCode;

  Languages(this.id, this.name, this.languageCode);

  static List<Languages> languageList() {
    return <Languages>[
      Languages(0, 'English', 'en'),
      Languages(1, 'عربي', 'ar'),
    ];
  }
}
