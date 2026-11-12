import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryDropdown extends StatelessWidget {
  final List<Country> countries;
  final Country? selectedCountry;
  final ValueChanged<Country?> onChanged;

  const CountryDropdown({
    super.key,
    required this.countries,
    required this.selectedCountry,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Country>(
          value: selectedCountry,
          hint: const Text('Selecciona un país'),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.deepPurple),
          items: countries.map((Country country) {
            return DropdownMenuItem<Country>(
              value: country,
              child: Text(
                '${country.name} (${country.countryCode})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}