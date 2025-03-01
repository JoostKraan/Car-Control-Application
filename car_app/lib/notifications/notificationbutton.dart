import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton ({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        color: Colors.white,
        'assets/notification-4-fill.svg');
  }
}
