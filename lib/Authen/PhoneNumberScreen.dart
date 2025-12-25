import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../BottomNavigation/BottomNavigation.dart';
import '../Screen/onBoardingScreen.dart';
import 'package:majorproject/utils.dart';
import '../Services/TranslationService.dart';
import 'otpScreen.dart';

class PhoneNumberScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ PHONE AUTH FLOW (OTP)
  void _verifyPhone() async {
    // final currentLang = ref.read(languageProvider);
    // However, snackbars should ideally use the helper from build context or similar.
    // We will define tr() inside methods or pass it around. For simplified usage, we can fetch it again or store in a variable if methods need it.
    // Actually, `AppLocalizations.of(ref.read(languageProvider), key)` is fine.

    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final phone = '+91${_phoneController.text.trim()}';

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _loading = false);
        showAppSnackbar(
          context: context,
          type: SnackbarType.error,
          description:
              "${AppLocalizations.of(ref.read(languageProvider), 'verification_failed')}: ${e.message}",
        );
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() => _loading = false);

        // 🔹 Check if user already exists
        final userDoc = await _firestore.collection('User').doc(phone).get();
        if (userDoc.exists) {
          // User already registered → go to BottomNavigation directly after OTP
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  OtpScreen(verificationId: verificationId, phoneNumber: phone),
            ),
          );
        } else {
          // New user → go to OTP for verification
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  OtpScreen(verificationId: verificationId, phoneNumber: phone),
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      appBar: AppBar(
        backgroundColor: const Color(0xff030A0E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OnBoardingScreen()),
            );
          },
        ),
        actions: [Image.asset("assets/app_logo 1.png")],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset("assets/number.png", height: 220),
                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tr('your_phone_number'),
                        style: const TextStyle(
                          color: Color(0xffAECCDD),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ✅ Phone Input Box
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Text(
                            "+91",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: tr('phone_number_hint'),
                                hintStyle: const TextStyle(
                                  color: Color(0xffAECCDD),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().length != 10) {
                                  return tr('enter_valid_number');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 🔹 Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _indicator(true),
                        _indicator(false, width: 20),
                        _indicator(true),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Bottom "Next" button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _loading ? null : _verifyPhone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        tr('next'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator(bool isCircle, {double width = 8}) {
    return Container(
      height: 8,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isCircle ? Colors.white : Colors.green,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(5),
      ),
    );
  }
}
