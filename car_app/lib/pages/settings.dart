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
                Builder(builder: (context) {
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
                }),
                Spacer(),
                Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: constants.fontSize * 1.2,
                      color: constants.fontColor),
                ),
                Spacer(),


              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Theme',style: TextStyle(color: constants.fontColor, fontSize: constants.fontSize*1.2),),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: OutlinedButton(
                      onPressed: () =>
                          context.read<ConstantsProvider>().setLightMode(),
                      child: Text('light'),
                      style: ButtonStyle(
                          foregroundColor:  MaterialStateProperty.all<Color>(
                            constants.isDarkMode ?
                              constants.fontColor : constants.secondaryColor) ,
                          backgroundColor: MaterialStateProperty.all<Color>(
                              constants.primaryColor)),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        context.read<ConstantsProvider>().setDarkMode(),
                    child: Text('dark'),
                    style: ButtonStyle(
                        foregroundColor:  MaterialStateProperty.all<Color>(
                            !constants.isDarkMode ?
                            constants.fontColor : constants.secondaryColor) ,
                        backgroundColor: MaterialStateProperty.all<Color>(
                            constants.primaryColor)),
                  ),
                  Spacer(),
                ],
              ),
            )
          ],
        )
        )
    );
  }
}
