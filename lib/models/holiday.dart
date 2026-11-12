class Holiday {
  final String date;
  final String localName;
  final String name;
  final String countryCode;

  Holiday({
    required this.date,
    required this.localName,
    required this.name,
    required this.countryCode,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: json['date'] ?? '',
      localName: json['localName'] ?? '',
      name: json['name'] ?? '',
      countryCode: json['countryCode'] ?? '',
    );
  }
}