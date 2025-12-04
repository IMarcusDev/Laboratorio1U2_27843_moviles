import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final Duration? delay;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              offset: const Offset(0, 8),
              blurRadius: 16,
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge de País
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                recipe.country.isEmpty ? "INTERNACIONAL" : recipe.country.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
    
            const SizedBox(height: 12),
    
            // Nombre
            Text(
              recipe.name.isNotEmpty ? recipe.name : "Sin nombre",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
    
            const SizedBox(height: 8),
    
            // Descripción
            Expanded(
              child: Text(
                recipe.description.isNotEmpty ? recipe.description : "Sin descripción disponible.",
                maxLines: 4,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ),
    
            const SizedBox(height: 12),
            
            // Línea divisora sutil
            Divider(color: Colors.grey.shade100, height: 20),
    
            // Footer
            Row(
              children: [
                const Icon(Icons.egg_rounded, size: 16, color: AppColors.accent),
                const SizedBox(width: 6),
                Text(
                  "${recipe.ingredients.length} ingredientes",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.border),
              ],
            )
          ],
        ),
      ),
    );
  }
}