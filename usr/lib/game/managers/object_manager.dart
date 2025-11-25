import 'dart:math';
import 'package:flame/components.dart';
import '../components/platform.dart';

class ObjectManager extends Component {
  final Random _rand = Random();
  final double gameSizeWidth;
  final double worldHeight;
  final double platformVerticalSpacing = 150;
  final double platformHorizontalVariance = 200;

  ObjectManager({required Vector2 gameSize, required this.worldHeight})
      : gameSizeWidth = gameSize.x;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _generateInitialPlatforms();
  }

  void _generateInitialPlatforms() {
    for (double y = worldHeight - 200; y > -worldHeight; y -= platformVerticalSpacing) {
      double x = _rand.nextDouble() * (gameSizeWidth - 100) + 50;
      parent?.add(Platform(position: Vector2(x, y)));
    }
  }

  void reset() {
    parent?.children.whereType<Platform>().forEach((platform) => platform.removeFromParent());
    _generateInitialPlatforms();
  }
}
