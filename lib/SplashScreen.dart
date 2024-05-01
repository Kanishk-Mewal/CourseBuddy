import 'package:flutter/material.dart';
import 'package:untitled5/callGPT.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Buddy',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideUpAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Define fade-in animation for the heading and button
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Define slide-up animation for the button
    _slideUpAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the screen is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated heading
            FadeTransition(
              opacity: _fadeInAnimation,
              child: Column(
                children: [
                  Image(image: AssetImage("assets/images/study.jpg")),
                  Text(
                    'Course Buddy',
                    style: TextStyle(
                      color: Color.fromARGB(0xFF, 0x45, 0x45, 0x45),
                      fontFamily: "Caveat",
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40), // Add some space between the heading and button

            // Animated button with elevation and curvature
            AnimatedBuilder(
              animation: _slideUpAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideUpAnimation.value),
                  child: child,
                );
              },
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 8, // Add elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                onPressed: () {
                  // Navigate to the next screen (e.g., home page) when the button is pressed
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GPTScreen(),
                    ),
                  );
                },
                child: Text("Start Creating", style: TextStyle(
                  fontFamily: "Montserrat"
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy home page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
