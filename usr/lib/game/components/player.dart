import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'platform.dart';
import '../miner_dash_game.dart';

class Player extends PositionComponent with CollisionCallbacks, HasGameRef<MinerDashGame> {
  Player({required super.position, required this.joystick})
      : super(size: Vector2(50, 50), anchor: Anchor.center);

  final JoystickComponent joystick;
  Vector2 _velocity = Vector2.zero();
  final double _gravity = 980.0;
  final double _jumpForce = 400.0;
  final double _moveSpeed = 300.0;
  int horizontalDirection = 0;
  bool _onGround = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFFFF0000),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    _velocity.y += _gravity * dt;

    // Horizontal movement from keyboard or joystick
    if (joystick.direction != JoystickDirection.idle) {
      horizontalDirection = (joystick.relativeDelta.x > 0) ? 1 : -1;
    }
    
    position.x += horizontalDirection * _moveSpeed * dt;

    // Clamp player position within screen bounds
    position.x = position.x.clamp(size.x / 2, game.size.x - size.x / 2);

    // Apply velocity
    position.y += _velocity.y * dt;

    // Reset horizontal direction if using keyboard
    if (joystick.direction == JoystickDirection.idle) {
      // Keyboard input is handled in the game class
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Platform) {
      if (_velocity.y > 0) {
        // Check if the player's bottom is colliding with the platform's top
        final playerBottom = position.y + size.y / 2;
        final platformTop = other.position.y;

        if ((playerBottom - platformTop).abs() < 5) { // Small tolerance
          _velocity.y = -_jumpForce;
          _onGround = true;
        }
      }
    }
  }

  void reset() {
    position = Vector2(game.size.x / 2, game.worldHeight - 200);
    _velocity = Vector2.zero();
  }
}
