import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // On web, show phone-sized container centered on screen
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              constraints: const BoxConstraints(
                maxWidth: 375, // iPhone width
                maxHeight: 812, // iPhone height
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: 375,
                  height: 812,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: const Size(375, 812),
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // On Windows, Android, iOS - full screen
    return child;
  }
}

