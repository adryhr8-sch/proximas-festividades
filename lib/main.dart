import 'package:flutter/material.dart';
import 'models/country.dart';
import 'models/holiday.dart';
import 'services/api_service.dart';
import 'widgets/country_dropdown.dart';
import 'widgets/holiday_list_tile.dart';

void main() {
  runApp(const HolidayApp());
}

class HolidayApp extends StatelessWidget {
  const HolidayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Próximas Festividades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> _countriesFuture;
  Future<List<Holiday>>? _holidaysFuture;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _countriesFuture = ApiService.fetchAvailableCountries();
  }

  void _onCountryChanged(Country? country) {
    if (country == null) return;
    setState(() {
      _selectedCountry = country;
      _holidaysFuture = ApiService.fetchNextPublicHolidays(country.countryCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Festividades Por País'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona un País:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<Country>>(
              future: _countriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LinearProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No se encontraron países');
                }

                return CountryDropdown(
                  countries: snapshot.data!,
                  selectedCountry: _selectedCountry,
                  onChanged: _onCountryChanged,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Próximas Festividades:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _holidaysFuture == null
                  ? const Center(
                      child: Text(
                        'Por favor selecciona un país para consultar.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : FutureBuilder<List<Holiday>>(
                      future: _holidaysFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No hay información de festividades disponible.'),
                          );
                        }

                        final holidays = snapshot.data!;
                        return ListView.builder(
                          itemCount: holidays.length,
                          itemBuilder: (context, index) {
                            return HolidayListTile(holiday: holidays[index]);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}