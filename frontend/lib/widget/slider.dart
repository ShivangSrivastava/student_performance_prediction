import 'package:flutter/material.dart';

class MySlider extends StatelessWidget {
  final int value;
  final String label;
  final List<int> range;
  final void Function(double value)? onChanged;
  final String? unit;
  const MySlider({
    Key? key,
    required this.value,
    required this.label,
    required this.range,
    this.onChanged,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                textScaler: const TextScaler.linear(1.35),
              ),
              Text('$value ${unit ?? ""}'),
            ],
          ),
        ),
        Slider(
          value: value.toDouble(),
          min: range[0].toDouble(),
          max: range[1].toDouble(),
          divisions: range[2],
          onChanged: onChanged,
          label: value.toString(),
        ),
      ],
    );
  }
}
