import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../views/home_page.dart';
import '../views/product_page.dart';
import '../views/login_page.dart';

class OptionMenu extends StatelessWidget {
  const OptionMenu({
    super.key,
    required this.text,
    required this.alignment,
    required this.color,
    required this.textColor,
    required this.width,
  });

  final String text;
  final Alignment alignment;
  final Color color;
  final Color textColor;
  final double width;

  static const Map<String, Widget> linksPage = {
    'Home': HomePage(),
    'My products': ProductsPage(),
    'Sign out': LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: (){
            Get.to(linksPage[text]);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: color,
                alignment: alignment,
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    color: textColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
