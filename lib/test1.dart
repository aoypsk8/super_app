import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'dart:ui';

class AnimationMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Animation Examples")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // _buildNavButton(context, "Implicit Animation", ImplicitAnimationExample()),
              // _buildNavButton(context, "Explicit Animation", ExplicitAnimationExample()),
              // _buildNavButton(context, "Hero Animation", HeroAnimationScreen1()),
              // _buildNavButton(context, "Lottie Animation", LottieAnimationExample()),
              _buildNavButton(context, "Animated CrossFade", AnimatedCrossFadeExample()),
              _buildNavButton(context, "Animated Rotation", AnimatedRotationExample()),
              _buildNavButton(context, "Animated Padding", AnimatedPaddingExample()),
              _buildNavButton(context, "Animated List", AnimatedListExample()),
              _buildNavButton(context, "PageView Animation", PageViewExample()),
              _buildNavButton(context, "Flip Animation", FlipAnimationExample()),
              _buildNavButton(context, "Shader Mask Text", ShaderMaskTextExample()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        },
        child: Text(title),
      ),
    );
  }
}

/// Example: Animated CrossFade
class AnimatedCrossFadeExample extends StatefulWidget {
  @override
  _AnimatedCrossFadeExampleState createState() => _AnimatedCrossFadeExampleState();
}

class _AnimatedCrossFadeExampleState extends State<AnimatedCrossFadeExample> {
  bool _showFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animated CrossFade")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _showFirst = !_showFirst;
            });
          },
          child: AnimatedCrossFade(
            duration: Duration(seconds: 1),
            firstChild: Container(width: 200, height: 200, color: Colors.blue),
            secondChild: Container(width: 200, height: 200, color: Colors.red),
            crossFadeState: _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
        ),
      ),
    );
  }
}

/// Example: Animated Rotation
class AnimatedRotationExample extends StatefulWidget {
  @override
  _AnimatedRotationExampleState createState() => _AnimatedRotationExampleState();
}

class _AnimatedRotationExampleState extends State<AnimatedRotationExample> {
  bool isRotated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animated Rotation")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isRotated = !isRotated;
            });
          },
          child: AnimatedRotation(
            turns: isRotated ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Icon(Icons.refresh, size: 100, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

/// Example: Animated Padding
class AnimatedPaddingExample extends StatefulWidget {
  @override
  _AnimatedPaddingExampleState createState() => _AnimatedPaddingExampleState();
}

class _AnimatedPaddingExampleState extends State<AnimatedPaddingExample> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animated Padding")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: AnimatedPadding(
            duration: Duration(seconds: 1),
            padding: isExpanded ? EdgeInsets.all(50) : EdgeInsets.all(10),
            child: Container(color: Colors.blue, width: 100, height: 100),
          ),
        ),
      ),
    );
  }
}

/// Example: Animated List
class AnimatedListExample extends StatefulWidget {
  @override
  _AnimatedListExampleState createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<int> _items = [];

  void _addItem() {
    _items.insert(0, _items.length);
    _listKey.currentState!.insertItem(0);
  }

  void _removeItem() {
    if (_items.isNotEmpty) {
      _listKey.currentState!.removeItem(
          0, (_, animation) => SizeTransition(sizeFactor: animation, child: ListTile(title: Text("Removed"))));
      _items.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animated List")),
      body: Column(
        children: [
          ElevatedButton(onPressed: _addItem, child: Text("Add Item")),
          ElevatedButton(onPressed: _removeItem, child: Text("Remove Item")),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(sizeFactor: animation, child: ListTile(title: Text("Item ${_items[index]}")));
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Example: PageView Animation
class PageViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PageView Animation")),
      body: PageView(
        children: [
          Container(color: Colors.blue, child: Center(child: Text("Page 1"))),
          Container(color: Colors.red, child: Center(child: Text("Page 2"))),
          Container(color: Colors.green, child: Center(child: Text("Page 3"))),
        ],
      ),
    );
  }
}

/// Example: Flip Animation
class FlipAnimationExample extends StatefulWidget {
  @override
  _FlipAnimationExampleState createState() => _FlipAnimationExampleState();
}

class _FlipAnimationExampleState extends State<FlipAnimationExample> {
  bool isFront = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flip Animation")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isFront = !isFront;
            });
          },
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isFront ? 0 : pi),
            child: isFront
                ? Container(width: 200, height: 200, color: Colors.blue)
                : Container(width: 200, height: 200, color: Colors.red),
          ),
        ),
      ),
    );
  }
}

/// Example: Shader Mask Text
class ShaderMaskTextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shader Mask Text")),
      body: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(colors: [Colors.blue, Colors.red]).createShader(bounds),
          child:
              Text("Gradient Text", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}
