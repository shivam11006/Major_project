import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onBoardingScreen.dart';
import '../Services/TranslationService.dart';

class IntroScreen extends ConsumerStatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    // Watch language provider to rebuild on change (though strictly intro screen might not change lang dynamically unless we add a selector here too)
    // But good practice if we back-nav to it.
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  // First Page
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/splash.png"),
                      const SizedBox(height: 20),
                      Image.asset("assets/app_logo.png", height: 60),
                      const SizedBox(height: 40),
                    ],
                  ),
                  // Add more pages if needed
                ],
              ),
            ),
            // Page Indicator
            SmoothPageIndicator(
              controller: _controller,
              count: 4, // number of pages
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.green,
                dotColor: Colors.grey.shade700,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 6,
              ),
            ),
            const SizedBox(height: 20),
            // Get Start Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to OnBoardingScreen with a custom fade animation
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            OnBoardingScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    tr('get_started'),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
