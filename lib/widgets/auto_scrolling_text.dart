import 'package:flutter/material.dart';

class AutoScrollingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double maxWidth;

  const AutoScrollingText({
    super.key,
    required this.text,
    required this.style,
    required this.maxWidth,
  });

  @override
  AutoScrollingTextState createState() => AutoScrollingTextState();
}

class AutoScrollingTextState extends State<AutoScrollingText>
    with SingleTickerProviderStateMixin {
  late double textWidth;
  late ScrollController _scrollController;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureTextWidth();
    });
  }

  void _measureTextWidth() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.rtl,
    )..layout();

    textWidth = textPainter.width;

    if (textWidth > widget.maxWidth) {
      _startScrolling();
    }
  }

  void _startScrolling() {
    if (!mounted) return;

    final double maxScrollExtent = textWidth - widget.maxWidth;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animationController!.addListener(() {
      if (_scrollController.hasClients) {
        final double newScrollPosition =
            _animationController!.value * maxScrollExtent;
        _scrollController.jumpTo(newScrollPosition);
      }
    });

    _animationController!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Text(
          widget.text,
          style: widget.style,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          overflow: TextOverflow.visible,
          softWrap: false,
        ),
      ),
    );
  }
}
