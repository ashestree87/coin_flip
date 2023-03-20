import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      title: 'Coin Flip',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: CoinFlipScreen(),
      ),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;
  bool _isHeads = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 7).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isHeads = Random().nextBool();
            _isAnimating = false;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    if (!_isAnimating) {
      setState(() {
        _isAnimating = true;
        _controller.reset();
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.rotationY(_animation.value * pi),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/coin.png',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 30),
            _isAnimating
                ? const Text(
                    'Flipping...',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  )
                : Text(
                    _isHeads ? 'Heads' : 'Tails',
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
          ],
        ),
      ),
    );
  }
}
