import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class RoundedBackButton extends StatelessWidget {
  const RoundedBackButton({
    this.icon = Icons.arrow_back_rounded,
    Key? key,
  }) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context.popRoute,
      tooltip: 'Back',
      icon: Icon(icon),
    );
  }
}
