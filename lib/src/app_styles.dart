import 'package:flutter/material.dart';

class AppStyles {
  static const alertHeader = TextStyle(
    decoration: TextDecoration.underline,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  static const alertSmall = TextStyle(fontSize: 9);

  static const alertNormal = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  static const splashHead = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static const splashTail = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const appBarStyle = TextStyle(
    color: AppColors.primary,
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );
  static const splashLoginHead = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );
  static const splashLoginBody = TextStyle(
    fontFamily: 'Inter',
    fontSize: 17,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );
  static const railSelectText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );
  static const railUnSelectText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    color: Colors.black54,
    fontWeight: FontWeight.w500,
  );

  static final newCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    boxShadow: [
      BoxShadow(
        color: AppColors.grayWhite.withOpacity(0.7),
        offset: const Offset(0, 1),
        spreadRadius: 0.5,
        blurRadius: 2.5,
      )
    ],
    color: Colors.white,
    // border: Border.all(width: 0.4, color: AppColors.tabPrimary)
  );

  static const newTextStyleCard = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.tabPrimary,
      shadows: [
        Shadow(
            // bottomLeft
            offset: Offset(-2.5, -2.5),
            color: Colors.white),
        Shadow(
            // bottomRight
            offset: Offset(2.5, -2.5),
            color: Colors.white),
        Shadow(
            // topRight
            offset: Offset(2.5, 2.5),
            color: Colors.white),
        Shadow(
            // topLeft
            offset: Offset(-2.5, 2.5),
            color: Colors.white),
      ]);
}
