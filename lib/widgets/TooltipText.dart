import 'package:flutter/material.dart';

class TooltipText extends StatelessWidget {
  const TooltipText({
    super.key,
    required this.text,
    required this.tooltip,
  });

  final String text;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text),
        const SizedBox(width: 8),
        Tooltip(
          message: tooltip,
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(milliseconds: 3000),
          child: const Icon(
            Icons.info_outline,
            size: 16,
          ),
        )
      ],
    );
  }
}
