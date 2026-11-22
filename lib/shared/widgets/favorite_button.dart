import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/core/error/failure.dart';
import 'package:meal_planner/core/theme.dart';
import 'package:meal_planner/shared/favorites/favorites_provider.dart';

/// Heart toggle for one recipe. Shows the shared favorites state, so every
/// heart for the same recipe updates together on every screen.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({required this.recipeId, this.size = 22, super.key});

  final String recipeId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(recipeId));

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () async {
          try {
            await ref.read(favoritesProvider.notifier).toggle(recipeId);
          } on Failure catch (failure) {
            // The heart is already rolled back; just tell the user.
            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(failure.message)));
          }
        },
        tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 34, height: 34),
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? AppColors.favoriteColor : AppColors.textColor,
          size: size,
        ),
      ),
    );
  }
}
