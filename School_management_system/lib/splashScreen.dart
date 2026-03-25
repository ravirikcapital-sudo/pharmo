import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: AppThemeColor.splashAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Future.delayed(AppThemeColor.splashScreenDuration, () {
      Navigator.pushReplacementNamed(context, '/admission-main');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/school.png',
                            height: AppThemeResponsiveness.getLogoSize(context) * 3.5, // Using responsive logo size
                          ),
                          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)), // Responsive spacing
                          Text(
                            'Royal Public School',
                            style: AppThemeResponsiveness.getHeadlineTextStyle(context), // Fixed: Using correct method
                          ),
                          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)), // Responsive spacing
                          Text(
                            'Your Future Starts Here',
                            style: AppThemeResponsiveness.getSubTitleTextStyle(context), // Fixed: Using correct method
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)), // Responsive spacing
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppThemeColor.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}