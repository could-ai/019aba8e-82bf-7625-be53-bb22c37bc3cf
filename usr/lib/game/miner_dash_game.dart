import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/player.dart';
import 'managers/object_manager.dart';

class MinerDashGame extends FlameGame with HasCollisionDetection, KeyboardEvents {
  MinerDashGame();

  late Player player;
  late double worldHeight;
  late ObjectManager objectManager;

  int score = 0;
  final scoreNotifier = ValueNotifier<int>(0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set the camera to a fixed viewport
    camera.viewfinder.anchor = Anchor.topLeft;

    // Calculate world height based on aspect ratio
    worldHeight = size.y * 5; // 5 screens high world

    // Add the player
    player = Player(
      position: Vector2(size.x / 2, worldHeight - 200),
      joystick: JoystickComponent(
        knob: CircleComponent(radius: 30, paint: Paint()..color = Colors.blue.withOpacity(0.5)),
        background: CircleComponent(radius: 70, paint: Paint()..color = Colors.blue.withOpacity(0.2)),
        margin: const EdgeInsets.only(left: 40, bottom: 40),
      ),
    );
    
    // Add the ObjectManager
    objectManager = ObjectManager(
      gameSize: size,
      worldHeight: worldHeight,
    );
    
    // Add components to the world
    world.add(objectManager);
    world.add(player);
    world.add(player.joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Camera follows the player, but only upwards
    if (player.position.y < camera.viewfinder.position.y) {
      camera.viewfinder.position = Vector2(0, player.position.y);
    }

    // Update score based on height
    final newScore = (worldHeight - player.position.y).floor();
    if (newScore > score) {
      score = newScore;
      scoreNotifier.value = score;
    }

    // Game over condition
    if (player.position.y > camera.viewfinder.position.y + size.y) {
      overlays.add('GameOver');
      pauseEngine();
    }
  }

  void resetGame() {
    score = 0;
    scoreNotifier.value = 0;
    player.reset();
    objectManager.reset();
    camera.viewfinder.position = Vector2(0, 0);
    resumeEngine();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isLeft) {
      player.horizontalDirection = -1;
    } else if (isRight) {
      player.horizontalDirection = 1;
    } else {
      player.horizontalDirection = 0;
    }
    return KeyEventResult.handled;
  }
}
