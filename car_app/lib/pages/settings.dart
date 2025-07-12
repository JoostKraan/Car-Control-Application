import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/constants-provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return Scaffold(
        backgroundColor: constants.primaryColor,
        body: SafeArea(
            child: Column(
          children: [
            Row(
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/');
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/arrow-back.svg',
                          width: constants.iconSize,
                          height: constants.iconSize,
                          color: constants.iconColor,
                        ));
                  }
                ),
                Spacer(),
                Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: constants.fontSize, color: constants.fontColor),
                ),
                Spacer(),
              ],
            )
          ],
        )));
  }
}
