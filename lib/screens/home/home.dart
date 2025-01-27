
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomessage/screens/home/menuCard.dart';
import 'package:geomessage/services/utils.dart';

import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).title),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
         SizedBox(height: 10),
          MenuCard(text: capitalizeFirstLetter(S.of(context).createMessage), iconData: Icons.send, route: '/home'),
          MenuCard(text: capitalizeFirstLetter(S.of(context).activeMessage), iconData: Icons.message, route: '/home'),
          MenuCard(text: capitalizeFirstLetter(S.of(context).sentMessages), iconData: Icons.message_outlined, route: '/home'),
        ]
      ),
    );
  }
}
