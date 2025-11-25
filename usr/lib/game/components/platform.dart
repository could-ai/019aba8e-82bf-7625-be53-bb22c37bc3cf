import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Platform extends PositionComponent {
  Platform({required super.position})
      : super(size: Vector2(100, 20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF8B4513), // SaddleBrown
    ));
  }
}
