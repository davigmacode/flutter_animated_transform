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
    this.alignment,
    required this.transform,
    required this.child,
  });

  /// Create an animated transform widget from direct transform values
  ///
  /// The [offset] prop used to moves a child element
  /// a certain distance away from its default position.
  ///
  /// The [scale] prop used to adjust the size of
  /// the child element relative to its original size.
  /// A value of 1 maintains the original size,
  /// while values greater than 1 enlarge
  /// and values less than 1 shrink the element.
  ///
  /// The [rotate] prop used to rotates child element
  /// by a specified number of degrees.
  /// Use a positive value for clockwise rotation
  /// or a negative value for counter-clockwise rotation.
  ///
  /// The [flipX] prop controls whether
  /// the child widget is flipped horizontally (mirrored).
  /// Setting flipX to true will cause the child
  /// to be displayed as if reflected across a vertical axis.
  ///
  /// The [flipY] prop controls whether
  /// the child widget is flipped vertically (inverted).
  /// Setting flipY to true will cause the child
  /// to be displayed as if reflected across a horizontal axis.
  AnimatedTransform.values({
    super.key,
    super.duration = const Duration(milliseconds: 200),
    super.curve = Curves.linear,
    Offset offset = Offset.zero,
    double scale = 1.0,
    double rotate = 0.0,
    bool flipX = false,
    bool flipY = false,
    this.alignment = Alignment.center,
    required this.child,
  }) : transform = Matrix4.identity()
          ..translate(offset.dx, offset.dy)
          ..scale(scale)
          ..rotateX(flipY ? _pi : 0.0)
          ..rotateY(flipX ? _pi : 0.0)
          ..rotateZ(_getRadiansFromDegrees(rotate));

  /// The transformation matrix to apply before painting the child.
  final Matrix4 transform;

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
  late Matrix4Tween transformTween;
  AlignmentGeometryTween? alignmentTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    transformTween = visitor(
      transformTween,
      widget.transform,
      (dynamic value) => Matrix4Tween(begin: value as Matrix4),
    ) as Matrix4Tween;

    alignmentTween = visitor(
      alignmentTween,
      widget.alignment,
      (dynamic value) =>
          AlignmentGeometryTween(begin: value as AlignmentGeometry),
    ) as AlignmentGeometryTween?;
  }

  @override
  Widget build(BuildContext context) {
    final transform = transformTween.evaluate(animation);
    final alignment = alignmentTween?.evaluate(animation);

    return Transform(
      transform: transform,
      alignment: alignment,
      child: widget.child,
    );
  }
}
