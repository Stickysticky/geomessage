import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {

  final String text;
  final IconData iconData;
  final String route;

  MenuCard({required this.text, required this.iconData, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 26.0, 16.0, 0),
        child:  Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(fontSize: 18.0),
                ),
                Spacer(),
                Icon(
                  iconData,
                  color: Colors.green.shade200,
                  size: 40,
                )
              ],
            )
        ),

      ),
    );
  }
}
