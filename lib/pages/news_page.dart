import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../data/news_data.dart';
import '../widgets/classified_card.dart';
import '../widgets/section_header.dart';
import '../widgets/footer.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'BREAKING NEWS',
            subtitle: 'DISPATCHES FROM THE MANATEK MONITORING DESK',
          ),
          ...newsArticles.asMap().entries.map((entry) {
            final article = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ClassifiedCard(
                accentColor: _categoryColor(article.category),
                child: _buildArticle(article),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 100 * entry.key),
                    duration: 400.ms,
                  ),
            );
          }),
          const SizedBox(height: 32),
          const AppFooter(),
        ],
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'BREAKING':
        return AppColors.warningOrange;
      case 'POLITICS':
        return const Color(0xFF7B68EE);
      case 'SCIENCE':
        return AppColors.bioTeal;
      case 'BUSINESS':
        return const Color(0xFFFFD700);
      case 'COMMUNITY':
        return AppColors.seaFoam;
      default:
        return AppColors.chromeSilver;
    }
  }

  Widget _buildArticle(NewsArticle article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _categoryColor(article.category).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                article.category,
                style: GoogleFonts.orbitron(
                  fontSize: 10,
                  color: _categoryColor(article.category),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            const Spacer(),
            Text(
              article.date,
              style: GoogleFonts.shareTechMono(
                fontSize: 11,
                color: AppColors.manateeGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          article.headline,
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          article.source,
          style: GoogleFonts.shareTechMono(
            fontSize: 11,
            color: AppColors.bioTeal,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          article.body,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.chromeSilver,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}
