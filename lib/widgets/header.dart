import 'package:flutter/material.dart';

import '../responsive.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    required this.fct,
    this.showTexField = true,
  }) : super(key: key);
  final String title;
  final Function fct;
  final bool showTexField;
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              fct();
            },
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27
              )
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        !showTexField
            ? Container()
            : const Expanded(
                child: Text(
                  'GHOR CHAI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: Colors.white
                  ),
                ),
              ),


        const SizedBox(width: 50)
      ],
    );
  }
}
