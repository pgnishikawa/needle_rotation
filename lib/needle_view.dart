import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final needleAngle = StateProvider<double>((ref) => 0);

class NeedleView extends StatelessWidget {
  const NeedleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter needle_rotation'),
        elevation: 2,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final angle = ref.watch(needleAngle);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('angle: ${angle.toStringAsFixed(2)}'),
        const SizedBox(height: 25),
        const NeedlePanel(),
        const SizedBox(height: 15),
        Slider(
          min: 0,
          max: 360,
          value: angle,
          onChanged: (value) {
            ref.read(needleAngle.notifier).state = value;
          },
        ),
      ],
    );
  }
}

class NeedlePanel extends ConsumerWidget {
  const NeedlePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final angle = ref.watch(needleAngle);
    return Container(
      width: 250,
      height: 250,
      color: Colors.blue.withOpacity(0.2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Needle(
            angle: angle,
            thickness: 5,
            length: 125,
            margin: 0.5,
            color: Colors.black87,
            shadowColor: Colors.black87,
          ),
          // 回転の中心点
          ClipOval(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class Needle extends StatelessWidget {
  final double angle;
  final double thickness;
  final double length;
  final double margin;
  final Color color;
  final Color? shadowColor;

  const Needle({
    Key? key,
    required this.angle,
    required this.thickness,
    required this.length,
    this.margin = 0.5,
    required this.color,
    this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * pi / 180,
      child: Transform.translate(
        offset: Offset(0, -length / 2),
        child: NeedleParts(
          thickness: thickness,
          length: length,
          margin: margin,
          color: color,
          shadowColor: shadowColor,
        ),
      ),
    );
  }
}

class NeedleParts extends StatelessWidget {
  const NeedleParts({
    super.key,
    required this.thickness,
    required this.length,
    required this.color,
    required this.margin,
    this.shadowColor,
  });

  final double thickness;
  final double length;
  final double margin;
  final Color color;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: thickness,
      height: length,
      child: Column(
        children: [
          // 針の実体部分
          Container(
            height: length * (1 - margin),
            decoration: BoxDecoration(
              color: color,
              boxShadow: [
                if (shadowColor != null)
                  BoxShadow(
                    color: shadowColor!,
                    blurRadius: thickness * 2,
                    spreadRadius: 1,
                  )
              ],
              borderRadius: BorderRadius.circular(thickness),
            ),
          ),
          // 針から回転の中心までの隙間
          SizedBox(height: length * margin),
        ],
      ),
    );
  }
}
