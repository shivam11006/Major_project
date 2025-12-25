import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/TranslationService.dart';

class GovtSchemesScreen extends ConsumerWidget {
  const GovtSchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    final List<Map<String, String>> schemes = [
      {
        "title": "DBT Agriculture Bihar",
        "url": "https://dbtagriculture.bihar.gov.in/",
      },
      {
        "title": "PM Kisan Samman Nidhi",
        "url": "https://pmkisan.gov.in/homenew.aspx",
      },
    ];

    Future<void> _launchURL(BuildContext context, String url) async {
      final Uri uri = Uri.parse(url);
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in external browser
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Could not launch $url: $e")));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('govt_schemes'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.language, color: Colors.green[800], size: 30),
              ),
              title: Text(
                scheme["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                scheme["url"]!,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              trailing: const Icon(Icons.open_in_new, color: Colors.grey),
              onTap: () => _launchURL(context, scheme["url"]!),
            ),
          );
        },
      ),
    );
  }
}
