import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: SvgPicture.asset("assets/icons/BackButton.svg"),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: 5),
      ],
    );
  }
}
