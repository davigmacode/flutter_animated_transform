import 'package:flutter/widgets.dart';

/// The PI constant.
const double _pi = 3.1415926535897932;

double _getRadiansFromDegrees(double degrees) {
  return degrees * _pi / 180;
}

/// A widget that allows to dynamically change the appearance of the child widget over time. It achieves this by combining the functionality of a transformation widget with animation capabilities.
class AnimatedTransform extends ImplicitlyAnimatedWidget {
  /// Create an animated transform widget
  const AnimatedTransform({
    super.key,
    super.duration = const Duration(milliseconds: 200),
    super.curve = Curves.linear,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotate = 0.0,
    this.flipX = false,
    this.flipY = false,
    this.alignment = Alignment.center,
    required this.child,
  });

  /// Moves a child element a certain distance away from its default position.
  final Offset offset;

  /// Adjust the size of the child element relative to its original size.
  /// A value of 1 maintains the original size,
  /// while values greater than 1 enlarge
  /// and values less than 1 shrink the element.
  final double scale;

  /// Rotates child element by a specified number of degrees.
  /// Use a positive value for clockwise rotation
  /// or a negative value for counter-clockwise rotation.
  final double rotate;

  /// Controls whether the child widget is flipped horizontally (mirrored).
  /// Setting flipX to true will cause the child
  /// to be displayed as if reflected across a vertical axis.
  final bool flipX;

  /// Controls whether the child widget is flipped vertically (inverted).
  /// Setting flipY to true will cause the child
  /// to be displayed as if reflected across a horizontal axis.
  final bool flipY;

  /// The alignment of the origin, relative to the size of the child, if [transform] is specified.
  ///
  /// When [transform] is null, the value of this property is ignored.
  ///
  /// See also:
  ///
  ///  * [Transform.alignment], which is set by this property.
  final AlignmentGeometry? alignment;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  AnimatedTransformState createState() => AnimatedTransformState();
}

class AnimatedTransformState
    extends AnimatedWidgetBaseState<AnimatedTransform> {
  Tween<Offset>? _tweenOffset;
  Tween<double>? _tweenScale;
  Tween<double>? _tweenRotateZ;
  Tween<double>? _tweenRotateX;
  Tween<double>? _tweenRotateY;
  AlignmentGeometryTween? _tweenAlignment;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tweenOffset = visitor(
      _tweenOffset,
      widget.offset,
      (dynamic value) => Tween<Offset>(begin: value),
    ) as Tween<Offset>?;

    _tweenScale = visitor(
      _tweenScale,
      widget.scale,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double>?;

    _tweenRotateZ = visitor(
      _tweenRotateZ,
      widget.rotate,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double>?;

    _tweenRotateX = visitor(
      _tweenRotateX,
      widget.flipY ? _pi : 0.0,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double>?;

    _tweenRotateY = visitor(
      _tweenRotateY,
      widget.flipX ? _pi : 0.0,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double>?;

    _tweenAlignment = visitor(
      _tweenAlignment,
      widget.alignment,
      (dynamic value) =>
          AlignmentGeometryTween(begin: value as AlignmentGeometry),
    ) as AlignmentGeometryTween?;
  }

  @override
  Widget build(BuildContext context) {
    final offset = _tweenOffset?.evaluate(animation) ?? Offset.zero;
    final scale = _tweenScale?.evaluate(animation) ?? 1.0;
    final rotateX = _tweenRotateX?.evaluate(animation) ?? 0.0;
    final rotateY = _tweenRotateY?.evaluate(animation) ?? 0.0;
    final rotateZ = _tweenRotateZ?.evaluate(animation) ?? 0.0;
    final alignment = _tweenAlignment?.evaluate(animation);

    final transform = Matrix4.identity()
      ..translate(offset.dx, offset.dy)
      ..scale(scale > 0 ? scale : 0.0)
      ..rotateZ(_getRadiansFromDegrees(rotateZ))
      ..rotateX(rotateX)
      ..rotateY(rotateY);

    return Transform(
      transform: transform,
      alignment: alignment,
      child: widget.child,
    );
  }
}
