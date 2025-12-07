import 'package:animated_gradient_border/animated_gradient_border.dart';
import 'package:flutter/material.dart';

class GradientBorderExample extends StatelessWidget {
  const GradientBorderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for contrast
      appBar: AppBar(
        title: const Text("Animated Gradient Border"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example 1: Fast, highly customized border
            AnimatedGradientBorder(
              borderWidth: 6,
              borderRadius: 25,
              speed: const Duration(milliseconds: 1500), // Faster rotation
              colors: const [
                Color(0xFF00FFFF), // Cyan
                Color(0xFF32CD32), // Lime Green
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 1.0], // Controls the gradient length
              child: Container(
                width: 250,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    "High Contrast Glow",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Example 2: Slower, soft white glow (The original request)
            AnimatedGradientBorder(
              borderWidth: 3,
              borderRadius: 30,
              speed: const Duration(milliseconds: 3500), // Faster rotation
              // Uses a soft white gradient that fades out quickly
              colors: const [
                Colors.white,
                Colors.transparent,
                Colors.transparent,
              ],
              stops: const [0.0, 0.15, 1.0], // Sharp fade to transparent
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text("Soft White Line"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MAIN EXAMPLE SETUP ---
void main() {
  runApp(
    const MaterialApp(
      home: GradientBorderExample(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
