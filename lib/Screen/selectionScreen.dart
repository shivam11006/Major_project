import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majorproject/Screen/onBoardingScreen.dart';
import '../Authen/PhoneNumberScreen.dart';
import '../DealerAuth/signup_screen.dart';
import '../Services/TranslationService.dart';

const Color _kPrimaryColor = Color(0xFF4CAF50);
const Color _kBackgroundColor = Color(0xff030A0E);
const Color _kAccentColor = Color(0xffAECCDD);
const Color _kOnPrimaryColor = Colors.white;

class SelectionScreen extends ConsumerStatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends ConsumerState<SelectionScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = selectedRole != null;
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      appBar: AppBar(
        backgroundColor: const Color(0xff030A0E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OnBoardingScreen()),
            );
          },
        ),
        actions: [Image.asset("assets/app_logo 1.png")],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/dadu_on_cart.png', // Replace with your image asset path
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // --- Role selection title ---
            const SizedBox(height: 16),
            Text(
              tr('choose_role'),
              style: const TextStyle(
                fontSize: 26,
                color: Color(0xffAECCDD),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              tr('role_desc'),
              style: const TextStyle(color: _kAccentColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // --- Role Toggle Buttons with modern styling ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ToggleButtons(
                isSelected: [
                  selectedRole == 'Farmer',
                  selectedRole == 'Dealer',
                ],
                onPressed: (int index) {
                  setState(() {
                    selectedRole = index == 0 ? 'Farmer' : 'Dealer';
                  });
                },
                borderRadius: BorderRadius.circular(16),
                selectedColor: _kOnPrimaryColor,
                color: _kAccentColor,
                fillColor: _kPrimaryColor.withOpacity(0.9),
                borderColor: _kAccentColor.withOpacity(0.5),
                selectedBorderColor: _kPrimaryColor,
                borderWidth: 2,
                constraints: const BoxConstraints(minHeight: 60),
                children: <Widget>[
                  RoleToggleButton(
                    icon: Icons.agriculture_outlined,
                    text: tr('farmer'),
                  ),
                  RoleToggleButton(
                    icon: Icons.storefront_outlined,
                    text: tr('dealer'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Next Button ---
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? _handleNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryColor,
                  disabledBackgroundColor: _kPrimaryColor.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  tr('next'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isButtonEnabled
                        ? _kOnPrimaryColor
                        : _kOnPrimaryColor.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (selectedRole == 'Farmer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
      );
    } else if (selectedRole == 'Dealer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    }
  }
}

class RoleToggleButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const RoleToggleButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
