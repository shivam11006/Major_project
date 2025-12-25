import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majorproject/Services/TranslationService.dart';
import 'package:majorproject/Services/GovtSchemesScreen.dart';

class ServicesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    final List<Map<String, dynamic>> services = [
      {
        "title": tr('govt_schemes'),
        "icon": Icons.account_balance,
        "color": Colors.green,
      },
      {
        "title": tr('crop_guides'),
        "icon": Icons.agriculture,
        "color": Colors.orange,
      },
      {
        "title": tr('market_prices'),
        "icon": Icons.account_balance_wallet,
        "color": Colors.blue,
      },
      {
        "title": tr('weather_forecast'),
        "icon": Icons.cloud,
        "color": Colors.purple.shade900,
      },
      {
        "title": tr('farmer_benefits'),
        "icon": Icons.local_florist,
        "color": Colors.teal,
      },
      {
        "title": tr('budget_calculator'),
        "icon": Icons.calculate,
        "color": Colors.greenAccent,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('farmer_services'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            return GestureDetector(
              onTap: () {
                // Check if it's the "Government Schemes" item
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GovtSchemesScreen(),
                    ),
                  );
                } else {
                  // Other services open normal details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ServiceDetailScreen(title: service["title"]),
                    ),
                  );
                }
              },
              child: Card(
                color: service["color"],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(service["icon"], size: 50, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      service["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Default details screen for other services
class ServiceDetailScreen extends ConsumerWidget {
  final String title;

  const ServiceDetailScreen({required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "${tr('details_for')} $title",
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
