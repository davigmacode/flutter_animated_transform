import 'package:flutter/material.dart';
import 'package:animated_transform/animated_transform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Transform Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Animated Transform Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _rotate = 0;
  double _scale = 1;
  bool _flipX = false;
  bool _flipY = false;

  void _increaseRotate() {
    setState(() {
      _rotate += 45;
    });
  }

  void _decreaseRotate() {
    setState(() {
      _rotate -= 45;
    });
  }

  void _increaseScale() {
    setState(() {
      _scale += .5;
    });
  }

  void _decreaseScale() {
    setState(() {
      _scale -= .5;
    });
  }

  void _toggleFlipX() {
    setState(() {
      _flipX = !_flipX;
    });
  }

  void _toggleFlipY() {
    setState(() {
      _flipY = !_flipY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black26,
                ),
              ),
              child: AnimatedTransform(
                rotate: _rotate,
                flipX: _flipX,
                flipY: _flipY,
                scale: _scale,
                child: const FlutterLogo(size: 100),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 5,
              children: [
                IconButton.outlined(
                  onPressed: _decreaseRotate,
                  icon: const Icon(Icons.rotate_left),
                ),
                IconButton.outlined(
                  onPressed: _decreaseScale,
                  icon: const Icon(Icons.keyboard_double_arrow_down),
                ),
                IconButton.outlined(
                  onPressed: _increaseScale,
                  icon: const Icon(Icons.keyboard_double_arrow_up),
                ),
                IconButton.outlined(
                  onPressed: _increaseRotate,
                  icon: const Icon(Icons.rotate_right),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 5,
              children: [
                IconButton.outlined(
                  onPressed: _toggleFlipX,
                  icon: const Icon(Icons.compare_arrows),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: IconButton.outlined(
                    onPressed: _toggleFlipY,
                    icon: const Icon(Icons.compare_arrows),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
