import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/core/theme.dart';
import 'package:meal_planner/features/recipe_details/recipe_details_screen.dart';
import 'package:meal_planner/shared/recipes/domain/recipe.dart';
import 'package:meal_planner/shared/recipes/providers/recipes_provider.dart';
import 'package:meal_planner/shared/widgets/recipe_card.dart';
import 'package:meal_planner/shared/widgets/state_views.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);
    void retry() => ref.invalidate(recipesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () => ref.refresh(recipesProvider.future),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _TopBar(),
                            SizedBox(height: 14),
                            _ProgressCard(),
                            SizedBox(height: 16),
                            Text(
                              'Recipes',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    ...recipesAsync.when(
                      loading: () => [_fill(const LoadingView())],
                      error: (error, _) => [
                        _fill(
                          ErrorView(
                            message: failureMessage(error),
                            onRetry: retry,
                          ),
                        ),
                      ],
                      data: (recipes) => recipes.isEmpty
                          ? [
                              _fill(
                                EmptyView(
                                  message: 'No recipes found.',
                                  action: RetryButton(onPressed: retry),
                                ),
                              ),
                            ]
                          : [_RecipeList(recipes: recipes)],
                    ),
                  ],
                ),
              ),
            ),
            const _BottomNavigation(),
          ],
        ),
      ),
    );
  }

  static Widget _fill(Widget child) {
    return SliverFillRemaining(hasScrollBody: false, child: child);
  }
}

class _RecipeList extends StatelessWidget {
  const _RecipeList({required this.recipes});

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      sliver: SliverList.separated(
        itemCount: recipes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(
            recipe: recipe,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RecipeDetailsScreen(recipe: recipe),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFE0E0E0), Color(0xFFB8B8B8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.person, size: 18, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, size: 25),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 30, height: 30),
          splashRadius: 18,
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ringSize = (constraints.maxWidth * 0.16).clamp(45.0, 62.0);
        final ringGap = (constraints.maxWidth * 0.025).clamp(8.0, 12.0);

        return Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF333333)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Progress",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'View more',
                    style: TextStyle(
                      color: AppColors.linkColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(child: _Calories()),
                  _ProgressRing(
                    value: 29,
                    label: 'Fat',
                    color: AppColors.fatColor,
                    size: ringSize,
                  ),
                  SizedBox(width: ringGap),
                  _ProgressRing(
                    value: 65,
                    label: 'Protein',
                    color: AppColors.proteinColor,
                    size: ringSize,
                  ),
                  SizedBox(width: ringGap),
                  _ProgressRing(
                    value: 85,
                    label: 'Carb',
                    color: AppColors.carbColor,
                    size: ringSize,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.motivationalBackgroundColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.celebration_outlined, size: 17),
                    SizedBox(width: 6),
                    Text(
                      "Keep the pace! You're doing great",
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Calories extends StatelessWidget {
  const _Calories();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calories',
          style: TextStyle(color: AppColors.mutedTextColor, fontSize: 10),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.local_fire_department, size: 15),
            SizedBox(width: 3),
            Text(
              '1,284',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.value,
    required this.label,
    required this.color,
    required this.size,
  });

  final int value;
  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + 7,
      child: CustomPaint(
        painter: _RingPainter(value: value, color: color, size: size),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$value%',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.mutedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.color,
    required this.size,
  });

  final int value;
  final Color color;
  final double size;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = this.size / 2 - 3;
    final background = Paint()
      ..color = const Color(0xFFF1F1F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final foreground = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, background);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * value / 100,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value;
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.wb_sunny_outlined, 'Today'),
      (Icons.restaurant_menu, 'Meal Plan'),
      (Icons.shopping_basket_outlined, 'Grocery List'),
      (Icons.chat_bubble_outline, 'Chat'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 13),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items
            .map(
              (item) => Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.$1, size: 21),
                    const SizedBox(height: 5),
                    Text(item.$2, style: AppColors.footerTextStyle),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
