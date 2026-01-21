
import 'package:flutter/material.dart';

class BG extends StatelessWidget {
  const BG({
    super.key, required this.child,
  });
final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/SignUp.png"),
                fit: BoxFit.cover,
              ),
            ),
    child: child,
    );
    
  }
}   