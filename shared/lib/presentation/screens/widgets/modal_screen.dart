import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModalScreen extends StatelessWidget {
  const ModalScreen({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.leadingIcon,
    this.isLogin = false,
  });
  final Widget child;
  final String title;
  final String subtitle;
  final Widget? leadingIcon;
  final bool? isLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1C36), // Dark Blue
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0E1C36), // Dark Blue
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  'packages/shared/assets/icons/trackpak-logo.svg',
                  width: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
