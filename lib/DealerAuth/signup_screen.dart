import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../FirebaseServices/node_model.dart';
import '../Services/TranslationService.dart';
import 'HomeScreenDealer.dart';
import 'package:majorproject/utils.dart';
import 'login_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _mobileController = TextEditingController();
  bool isPasswordHide = true;

  bool _isLoading = false;
  bool _isChecked = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // ✅ Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      String uid = userCredential.user!.uid; // ✅ Get the user's UID

      // ✅ Create SignUp model
      SignUp userModel = SignUp(
        _firstNameController.text.trim(),
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _mobileController.text.trim(),
        _passwordController.text.trim(),
      );

      // ✅ Store user data in Firestore
      await _firestore
          .collection('Dealer')
          .doc(uid)
          .set(SignUp.toMap(userModel));

      // ✅ Navigate to Registration screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPanel()),
      );

      showAppSnackbar(
        context: context,
        type: SnackbarType.success,
        description: AppLocalizations.of(
          ref.read(languageProvider),
          'account_created',
        ),
      );
    } on FirebaseAuthException catch (e) {
      showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description: e.message ?? 'Signup failed',
      );
    } catch (e) {
      showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description:
            "${AppLocalizations.of(ref.read(languageProvider), 'error')}: $e",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return Scaffold(
      backgroundColor: const Color(0xFF002E2E),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/app_logo.png", height: 100),
                const SizedBox(height: 30),

                // First Name
                TextFormField(
                  controller: _firstNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(tr('first_name')),
                  validator: (v) =>
                      v == null || v.isEmpty ? tr('enter_full_name') : null,
                ),
                const SizedBox(height: 16),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(tr('username')),
                  validator: (v) =>
                      v == null || v.isEmpty ? tr('enter_username') : null,
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(tr('email')),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@gmail.com')
                      ? tr('enter_valid_email')
                      : null,
                ),
                const SizedBox(height: 16),

                // Mobile Number Field
                TextFormField(
                  controller: _mobileController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(tr('mobile_number')),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.length < 10
                      ? tr('enter_valid_mobile')
                      : null,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: tr('password'),
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF355858),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHide = !isPasswordHide;
                        });
                      },
                      icon: Icon(
                        isPasswordHide
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  obscureText: isPasswordHide,

                  validator: (v) =>
                      v == null || v.length < 6 ? tr('min_6_chars') : null,
                ),
                const SizedBox(height: 16),

                // Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      activeColor: Colors.greenAccent,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        tr('agree_terms'),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Submit Button
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.greenAccent)
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isChecked
                                ? Colors.greenAccent.shade400
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _isChecked ? _signup : null,
                          child: Text(
                            tr('sign_up'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr('already_have_account'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        tr('sign_in'),
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Reusable InputDecoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF355858),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
