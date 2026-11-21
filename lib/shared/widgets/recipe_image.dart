import 'package:flutter/material.dart';
import 'package:meal_planner/core/theme.dart';

/// Network recipe image with a loading box and a placeholder for
/// missing or broken images.
class RecipeImage extends StatelessWidget {
  const RecipeImage(
    this.url, {
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String? url;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null) return _placeholder();

    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: fit,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _box(),
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _box({Widget? child}) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.secondaryColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _placeholder() {
    return _box(
      child: const Icon(
        Icons.restaurant,
        size: 40,
        color: AppColors.mutedTextColor,
      ),
    );
  }
}
