import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  // List of services
  final List<Map<String, dynamic>> services = [
    {
      "title": "Government Schemes",
      "icon": Icons.account_balance,
      "color": Colors.green,
    },
    {
      "title": "Crop Planting Guides",
      "icon": Icons.agriculture,
      "color": Colors.orange,
    },
    {
      "title": "Market Prices",
      "icon": Icons.account_balance_wallet,
      "color": Colors.blue,
    },
    {
      "title": "Weather Forecast",
      "icon": Icons.cloud,
      "color": Colors.purple,
    },
    {
      "title": "Farmer Benefits",
      "icon": Icons.local_florist,
      "color": Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Services"),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            return GestureDetector(
              onTap: () {
                // TODO: Navigate to service details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceDetailScreen(
                      title: service["title"],
                    ),
                  ),
                );
              },
              child: Card(
                color: service["color"],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      service["icon"],
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      service["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
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

// Placeholder screen for service details
class ServiceDetailScreen extends StatelessWidget {
  final String title;

  const ServiceDetailScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green[800],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Details for $title will appear here",
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
