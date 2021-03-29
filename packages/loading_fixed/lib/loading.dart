import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'indicator.dart';
import 'indicators/fixed_ball_scale_indicator.dart';

// ignore: must_be_immutable
class FixedLoadingWidget extends StatefulWidget {
  Indicator indicator;
  double size;
  Color color;

  FixedLoadingWidget({this.indicator,  this.size = 50.0, this.color = Colors.white}) {
    if (indicator == null) {
      indicator = BallScaleIndicator();
    } else {
      this.indicator = indicator;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return FixedLoadingWidgetState(indicator, size);
  }
}

class FixedLoadingWidgetState extends State<FixedLoadingWidget> with TickerProviderStateMixin {
  Indicator indicator;
  double size;

  FixedLoadingWidgetState(this.indicator, this.size);

  @override
  void initState() {
    super.initState();
    indicator.context = this;
    indicator.start();
  }

  @override
  void dispose() {
    indicator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(indicator, widget.color),
      size: Size.square(size),
    );
  }
}

class _Painter extends CustomPainter {
  Indicator indicator;
  Color color;
  Paint defaultPaint;

  _Painter(this.indicator, this.color) {
    defaultPaint = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..color = color
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    indicator.paint(canvas, defaultPaint, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
