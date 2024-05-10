import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthNotch extends StatelessWidget {
  const AuthNotch({super.key});

  @override
  Widget build(BuildContext context) {
    TextButton.styleFrom(
      minimumSize: const Size(32, 32),
      backgroundColor: Colors.grey,
    );

    return Row(
      children: [
        FloatingActionButton.small(onPressed: () => (
            Navigator.pop(context)
        ),
          elevation: 1, child: const Icon(
            Icons.arrow_back
        ),
        ),
        const SizedBox(width: 16),
        Text(
          "Sign in",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
