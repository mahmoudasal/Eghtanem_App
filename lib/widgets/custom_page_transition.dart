import 'package:flutter/material.dart';

Route createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration:
        const Duration(milliseconds: 500), // Adjust the duration as needed
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide transition
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final curve = Curves.easeOutQuad;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var slideAnimation = animation.drive(tween);

      // Fade transition
      var fadeAnimation = animation.drive(CurveTween(curve: Curves.easeIn));

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}
