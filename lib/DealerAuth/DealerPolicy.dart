import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Services/TranslationService.dart';

class DealerPolicy extends ConsumerWidget {
  const DealerPolicy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('privacy_policy')),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('privacy_title_full'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Effective Date: [22- 10 - 2025 ]\nApp Name: [Agri Shakti]\nCompany Name: [Dr. M.G.R. EDUCATIONAL AND RESEARCH INSTITUTE]\nContact Email: [shivamkr8540@gmail.com]",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "1. Introduction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Welcome to [AGRI SHAKTI]. This Privacy Policy and Terms of Use describe how we collect, use, and protect your information when you use our mobile application. "
              "This app allows Dealers to post their products and directly connect with Farmers for business and trade purposes.\n\n"
              "By using this app, you agree to these terms. If you do not agree, please stop using the app immediately.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "2. Information We Collect",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "We may collect the following information from Dealers:\n"
              "- Personal Information: Name, phone number, email, business name, and address.\n"
              "- Profile and Product Data: Product images, descriptions, prices, and posts shared by you.\n"
              "- Device Information: Device type, operating system, and app version.\n"
              "- Usage Data: App interactions, login history, and communication with farmers.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "3. How We Use Your Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "We use your information to:\n"
              "- Display your profile and products to Farmers and other users.\n"
              "- Facilitate direct communication between Dealers and Farmers.\n"
              "- Improve app performance and user experience.\n"
              "- Detect and prevent fraud, misuse, or illegal activities.\n"
              "- Send important updates, notifications, or promotional offers (with your consent).",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "4. Sharing of Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "We do not sell or share your personal information with third parties except:\n"
              "- When required by law or government authorities.\n"
              "- To protect the rights, property, or safety of users or our platform.\n"
              "- With your consent, for verified business purposes.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "5. Dealer Responsibilities",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "As a Dealer, you agree to:\n"
              "- Post only genuine and legal products.\n"
              "- Provide accurate and truthful information.\n"
              "- Respect all users and avoid abusive or fraudulent behavior.\n"
              "- Not use the platform for illegal trade, spam, or harassment.\n\n"
              "Any misuse of the platform — including fraud, misleading posts, or harassment — will result in account suspension or permanent ban, and possible legal action.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "6. Farmer Communication",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Dealers can contact Farmers directly through the app’s communication features. "
              "You are solely responsible for the content of your messages and interactions. "
              "We may monitor or review messages if there are reports of misuse or suspicious activity.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "7. Data Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "We use modern security measures to protect your personal data. However, no system is 100% secure. "
              "We recommend that you keep your login credentials private and contact us immediately if you notice unauthorized access.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "8. Data Retention",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Your data will be stored as long as your account is active or as required by law. "
              "You can request to delete your account and data by contacting us at [your@email.com].",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "9. Changes to This Policy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "We may update this policy from time to time. When we do, we will notify you within the app or via email. "
              "Continued use of the app means you accept the updated terms.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "10. Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "If you have any questions or concerns about this Privacy Policy or misuse reports, please contact us at:\n"
              "📩 Email: [shivamkr8540@gmail.com]\n🏢 Company Name: [Dr. M.G.R. EDUCATIONAL AND RESEARCH INSTITUTE]",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "11. Punishment for Misuse",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "If any Dealer is found to:\n"
              "- Post fake or misleading information,\n"
              "- Engage in illegal, abusive, or fraudulent activity, or\n"
              "- Violate other users’ rights —\n\n"
              "then [AGRI SHAKTI] reserves full authority to:\n"
              "- Remove such content immediately,\n"
              "- Suspend or permanently delete the account, and\n"
              "- Report the incident to legal authorities if necessary.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                "© [AGRI SHAKTI ] | All Rights Reserved",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
