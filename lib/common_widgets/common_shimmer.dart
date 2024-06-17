import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmer extends StatelessWidget {
  final Widget child;
  const CommonShimmer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.secondary,
      highlightColor: theme.colorScheme.onSecondary,
      enabled: true,
      child: child,
    );
  }
}

class ShimmerGrayBox extends StatelessWidget {
  final double height;
  final double width;
  final double? radius;
  const ShimmerGrayBox(
      {required this.height, required this.width, this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(radius ?? 5),
      ),
    );
  }
}
