import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle? style; // ✅ Add this to accept optional style

  const BlinkingText({
    required this.text,
    this.style, // ✅ Constructor support for style
    Key? key,
  }) : super(key: key);

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    toggleVisibility();
  }

  void toggleVisibility() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _visible = !_visible;
        });
        toggleVisibility();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Text(
        widget.text,
        style: widget.style ?? const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
