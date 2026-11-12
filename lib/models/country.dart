class Country {
  final String countryCode;
  final String name;

  Country({required this.countryCode, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['countryCode'] ?? '',
      name: json['name'] ?? '',
    );
  }
}