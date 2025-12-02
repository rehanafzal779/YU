import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neat_now/models/employee_models.dart';
import 'package:neat_now/widgets/employee/responsive_employee_helper.dart';

/// EmployeeAnalyticsTab - Displays analytics and charts
class EmployeeAnalyticsTab extends StatelessWidget {
  final Future<AnalyticsData> analyticsFuture;
  final EmployeeResponsiveData responsive;

  const EmployeeAnalyticsTab({
    super.key,
    required this.analyticsFuture,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnalyticsData>(
      future: analyticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors. green),
          );
        }
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }
        return _buildAnalyticsContent(snapshot.data!);
      },
    );
  }

  Widget _buildAnalyticsContent(AnalyticsData analytics) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets. all(responsive.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              responsive.adaptiveText(
                'Reports Analytics',
                micro: 'Stats',
                nano: 'Analytics',
                mini: 'Analytics',
              ),
              style: GoogleFonts.poppins(
                fontSize: responsive.fontSize(20),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: responsive. padding),

          // Growth card
          _buildGrowthCard(analytics),
          SizedBox(height: responsive.padding),

          // Reports over time chart
          _buildChartCard(
            title: responsive.adaptiveText(
              'Reports Over Time',
              micro: 'Time',
              nano: 'Timeline',
            ),
            child: _buildReportsChart(analytics),
          ),
          SizedBox(height: responsive.padding),

          // Waste distribution
          _buildChartCard(
            title: responsive.adaptiveText(
              'Waste Distribution',
              micro: 'Waste',
              nano: 'Distrib',
            ),
            child: _buildWasteDistribution(analytics),
          ),
          SizedBox(height: responsive.padding),

          // Top locations
          _buildChartCard(
            title: responsive.adaptiveText(
              'Top Reporting Locations',
              micro: 'Locs',
              nano: 'Locations',
            ),
            child: _buildTopLocations(analytics),
          ),

          SizedBox(height: responsive.dimension(100)),
        ],
      ),
    );
  }

  Widget _buildGrowthCard(AnalyticsData analytics) {
    final isPositive = analytics.growthRate >= 0;

    return Card(
      elevation: responsive.showShadows ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.borderRadius),
      ),
      child: Container(
        padding: EdgeInsets.all(responsive.padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius. circular(responsive.borderRadius),
          gradient: LinearGradient(
            colors: isPositive
                ?  [Colors.green. shade400, Colors. green.shade600]
                : [Colors.red.shade400, Colors.red.shade600],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    responsive.adaptiveText(
                      'Monthly Growth',
                      micro: 'Growth',
                      nano: 'Growth',
                    ),
                    style: GoogleFonts. poppins(
                      fontSize: responsive.fontSize(12),
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: responsive. microPadding),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${isPositive ? '+' : ''}${analytics.growthRate. toStringAsFixed(1)}%',
                      style: GoogleFonts.poppins(
                        fontSize: responsive. fontSize(28),
                        fontWeight: FontWeight. bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (responsive.showSecondaryText) ...[
                    SizedBox(height: responsive. microPadding),
                    Text(
                      'vs last month',
                      style: GoogleFonts.poppins(
                        fontSize: responsive.fontSize(11),
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: responsive.dimension(48),
              color: Colors.white. withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      elevation: responsive.showShadows ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets. all(responsive.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: GoogleFonts. poppins(
                  fontSize: responsive.fontSize(16),
                  fontWeight: FontWeight. w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: responsive.padding),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildReportsChart(AnalyticsData analytics) {
    final labels = analytics.reportsOverTime['labels'] as List<dynamic>?  ??
        ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final data = analytics.reportsOverTime['data'] as List<dynamic>? ??
        [10, 20, 15, 25, 22, 30];

    final maxValue = data.cast<num>().reduce((a, b) => a > b ? a : b). toDouble();

    return Container(
      height: responsive.chartHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey. shade200),
        borderRadius: BorderRadius.circular(responsive.borderRadius),
      ),
      padding: EdgeInsets. all(responsive.microPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(labels.length, (index) {
          final value = (data[index] as num).toDouble();
          final heightPercent = maxValue > 0 ? value / maxValue : 0.0;

          return Expanded(
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.nanoPadding),
          child: Column(
          mainAxisAlignment: MainAxisAlignment. end,
          children: [
          if (responsive.showSecondaryText)
          Text(
          value.toInt(). toString(),
          style: GoogleFonts.poppins(
          fontSize: responsive.fontSize(10),
          fontWeight: FontWeight. w600,
          color: Colors. grey[700],
          ),
          ),
          SizedBox(height: responsive. nanoPadding),
          Expanded(
          child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
          heightFactor: heightPercent. clamp(0.1, 1.0),
          child: Container(
          decoration: BoxDecoration(
          gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.green, Colors. lightGreen],
          ),
          borderRadius: BorderRadius. vertical(
          top: Radius.circular(responsive. borderRadius / 2),
          ),
          ),
          ),
          ),
          ),
          ),
          SizedBox(height: responsive.nanoPadding),
          FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
          responsive.isMicroScreen
          ? labels[index]. toString(). substring(0, 1)
              : labels[index]. toString(),
          style: GoogleFonts.poppins(
          fontSize: responsive.fontSize(10),
          color: Colors.grey[600],
          ),
          ),
          ),
          ],
          ),
          ),
          );
        }),
      ),
    );
  }

  Widget _buildWasteDistribution(AnalyticsData analytics) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors. orange,
      Colors.red,
      Colors.purple,
    ];

    return Column(
      children: analytics.wasteDistribution.entries.toList(). asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final color = colors[index % colors.length];

        return Padding(
          padding: EdgeInsets.symmetric(vertical: responsive.nanoPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: responsive.dimension(12),
                    height: responsive.dimension(12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius. circular(3),
                    ),
                  ),
                  SizedBox(width: responsive. microPadding),
                  Expanded(
                    child: Text(
                      item.key,
                      style: GoogleFonts. poppins(
                        fontSize: responsive.fontSize(12),
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item.value}%',
                    style: GoogleFonts.poppins(
                      fontSize: responsive.fontSize(12),
                      fontWeight: FontWeight. w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.nanoPadding),
              ClipRRect(
                borderRadius: BorderRadius.circular(responsive.borderRadius / 2),
                child: LinearProgressIndicator(
                  value: item.value / 100,
                  backgroundColor: color. withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: responsive.dimension(6),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopLocations(AnalyticsData analytics) {
    return Column(
      children: analytics.topLocations.take(5).map((location) {
        final locationMap = location as Map<String, dynamic>;
        return Padding(
          padding: EdgeInsets. symmetric(vertical: responsive.microPadding),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets. all(responsive.microPadding),
                decoration: BoxDecoration(
                  color: Colors.blue. withOpacity(0.1),
                  borderRadius: BorderRadius.circular(responsive.borderRadius),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: Colors.blue,
                  size: responsive.iconSize(16),
                ),
              ),
              SizedBox(width: responsive.padding),
              Expanded(
                child: Text(
                  locationMap['name'] ??  'Unknown',
                  style: GoogleFonts.poppins(
                    fontSize: responsive. fontSize(12),
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow. ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.microPadding,
                  vertical: responsive.nanoPadding,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(responsive.borderRadius),
                ),
                child: Text(
                  responsive.adaptiveText(
                    '${locationMap['reports']} reports',
                    micro: '${locationMap['reports']}',
                    nano: '${locationMap['reports']}',
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: responsive.fontSize(10),
                    fontWeight: FontWeight. w600,
                    color: Colors. green,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: responsive.dimension(48),
            color: Colors.red,
          ),
          SizedBox(height: responsive.padding),
          Text(
            'Error loading analytics',
            style: GoogleFonts. poppins(
              fontSize: responsive. fontSize(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}