import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/model/dashboard/dashboardItem.dart';

class DashboardCard extends StatelessWidget {
  final DashboardItem item;

  const DashboardCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final double borderRadius = AppThemeResponsiveness.getCardBorderRadius(context);
    final double elevation = AppThemeResponsiveness.getCardElevation(context);
    final double padding = AppThemeResponsiveness.getDashboardCardPadding(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: elevation,
            offset: Offset(0, elevation * 0.5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Stack(
              children: [
                SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: item.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          item.icon,
                          size: 28,
                          color: item.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        child: Text(
                          item.title,
                          style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: Text(
                          item.subtitle,
                          style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.badge != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 20),
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade500,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          item.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardGrid extends StatelessWidget {
  final List<DashboardItem> items;

  const DashboardGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppThemeResponsiveness.getDashboardGridCrossAxisCount(context),
        crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
        childAspectRatio: AppThemeResponsiveness.getDashboardGridChildAspectRatio(context),
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => DashboardCard(item: items[index]),
    );
  }
}