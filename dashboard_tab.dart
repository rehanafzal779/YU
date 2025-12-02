import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neat_now/models/employee_models.dart';
import 'package:neat_now/widgets/employee/responsive_employee_helper.dart';
import 'package:neat_now/widgets/employee/components/stat_card.dart';
import 'package:neat_now/widgets/employee/components/feature_card.dart';

/// EmployeeDashboardTab - Main dashboard overview
class EmployeeDashboardTab extends StatelessWidget {
  final Future<EmployeeStats> statsFuture;
  final Function(int) onNavigateToTab;
  final VoidCallback onRefresh;
  final Map<String, dynamic> employeeData;
  final bool isDemoMode;
  final EmployeeResponsiveData responsive;

  const EmployeeDashboardTab({
    super.key,
    required this. statsFuture,
    required this. onNavigateToTab,
    required this.onRefresh,
    required this. employeeData,
    required this.isDemoMode,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async => onRefresh(),
        color: Colors.green,
        child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
        SliverToBoxAdapter(
        child: Column(
        children: [
            // Header
            if (! responsive.isMicroScreen) _buildHeader(),

    // Demo mode indicator
    if (isDemoMode) _buildDemoIndicator(),

    // Stats Cards
    Padding(
    padding: EdgeInsets.all(responsive.padding),
    child: FutureBuilder<EmployeeStats>(
    future: statsFuture,
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return _buildStatsLoading();
    }
    if (snapshot.hasError) {
    return _buildErrorWidget(context, snapshot.error. toString());
    }
    return _buildStatsGrid(snapshot.data! );
    },
    ),
    ),

    // Quick Actions
    if (! responsive.isMicroScreen) ...[
    Padding(
    padding: EdgeInsets.symmetric(horizontal: responsive. padding),
    child: Row(
    children: [
    Text(
    responsive.adaptiveText(
    'Quick Actions',
    tiny: 'Actions',
    nano: 'Actions',
    ),
    style: GoogleFonts.poppins(
    fontSize: responsive.fontSize(18),
    fontWeight: FontWeight. bold,
    color: Colors.black87,
    ),
    ),
    ],
    ),
    ),
    SizedBox(height: responsive.padding),
    _buildFeaturesGrid(),
    ],

    SizedBox(height: responsive.dimension(100)),
    ],
    ),
    ),
    ],
    ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets. all(responsive.padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green. shade600, Colors.blue.shade600],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: responsive.dimension(50),
                  height: responsive.dimension(50),
                  decoration: BoxDecoration(
                    color: Colors.white. withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white. withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      (employeeData['name'] ?? 'E'). toString().isNotEmpty
                          ? (employeeData['name'] ?? 'E'). toString()[0].toUpperCase()
                          : 'E',
                      style: GoogleFonts.poppins(
                        fontSize: responsive.fontSize(22),
                        fontWeight: FontWeight. bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: responsive.padding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          responsive.adaptiveText(
                            'Welcome, ${employeeData['name'] ?? 'Employee'}!',
                            tiny: 'Welcome! ',
                            nano: 'Hello! ',
                            mini: 'Welcome!',
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight. bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (responsive.showSecondaryText)
                        Text(
                          'Manage and monitor user activities',
                          style: GoogleFonts. poppins(
                            fontSize: responsive.fontSize(12),
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoIndicator() {
    return Container(
      margin: EdgeInsets. all(responsive.padding),
      padding: EdgeInsets.symmetric(
        horizontal: responsive. padding,
        vertical: responsive.microPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(responsive.borderRadius),
        border: Border.all(color: Colors.orange. withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons. science_rounded,
            color: Colors.orange,
            size: responsive.iconSize(18),
          ),
          SizedBox(width: responsive.microPadding),
          Expanded(
            child: Text(
              responsive.adaptiveText(
                '🔧 Demo Mode - Using sample data',
                micro: '🔧',
                nano: 'Demo',
                mini: 'Demo Mode',
              ),
              style: GoogleFonts.poppins(
                fontSize: responsive.fontSize(12),
                color: Colors.orange[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(EmployeeStats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: responsive.gridColumns,
      childAspectRatio: responsive.cardAspectRatio,
      crossAxisSpacing: responsive.padding,
      mainAxisSpacing: responsive.padding,
      children: [
        EmployeeStatCard(
          title: 'Total Photos',
          value: stats.totalPhotos.toString(),
          icon: Icons.photo_library_rounded,
          color: Colors.blue,
          trend: '+12%',
          responsive: responsive,
        ),
        EmployeeStatCard(
          title: 'Active Users',
          value: stats.activeUsers.toString(),
          icon: Icons.people_rounded,
          color: Colors.green,
          trend: '+5%',
          responsive: responsive,
        ),
        EmployeeStatCard(
          title: 'Pending Reports',
          value: stats.pendingReports.toString(),
          icon: Icons.pending_actions_rounded,
          color: Colors.orange,
          trend: '-3%',
          responsive: responsive,
        ),
        EmployeeStatCard(
          title: 'Resolved Reports',
          value: stats.resolvedReports.toString(),
          icon: Icons. check_circle_rounded,
          color: Colors.purple,
          trend: '+8%',
          responsive: responsive,
        ),
      ],
    );
  }

  Widget _buildStatsLoading() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: responsive.gridColumns,
      childAspectRatio: responsive.cardAspectRatio,
      crossAxisSpacing: responsive.padding,
      mainAxisSpacing: responsive.padding,
      children: List.generate(4, (index) => _buildStatCardLoading()),
    );
  }

  Widget _buildStatCardLoading() {
    return Card(
      elevation: responsive.showShadows ? 4 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets. all(responsive.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: responsive.dimension(36),
                  height: responsive.dimension(36),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius. circular(responsive.borderRadius),
                  ),
                ),
                if (responsive.showTrends)
                  Container(
                    width: responsive.dimension(40),
                    height: responsive.dimension(18),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius. circular(6),
                    ),
                  ),
              ],
            ),
            SizedBox(height: responsive.microPadding),
            Container(
              width: responsive.dimension(50),
              height: responsive.dimension(20),
              decoration: BoxDecoration(
                color: Colors. grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: responsive.nanoPadding),
            Container(
              width: responsive.dimension(70),
              height: responsive.dimension(14),
              decoration: BoxDecoration(
                color: Colors. grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    final features = [
      {
        'title': 'View Reports',
        'icon': Icons.analytics_rounded,
        'color': Colors. purple,
        'tabIndex': 1,
      },
      {
        'title': 'User Management',
        'icon': Icons.people_alt_rounded,
        'color': Colors. orange,
        'tabIndex': 2,
      },
      {
        'title': 'Analytics',
        'icon': Icons.bar_chart_rounded,
        'color': Colors.blue,
        'tabIndex': 3,
      },
      {
        'title': 'Photo Gallery',
        'icon': Icons.photo_rounded,
        'color': Colors.green,
        'tabIndex': 4,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive. padding),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: responsive.gridColumns,
        childAspectRatio: responsive.cardAspectRatio,
        crossAxisSpacing: responsive.padding,
        mainAxisSpacing: responsive.padding,
        children: features.map((feature) {
          return EmployeeFeatureCard(
            title: feature['title'] as String,
            icon: feature['icon'] as IconData,
            color: feature['color'] as Color,
            onTap: () => onNavigateToTab(feature['tabIndex'] as int),
            responsive: responsive,
          );
        }). toList(),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets. all(responsive.padding),
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
              responsive.adaptiveText(
                'Something went wrong',
                micro: 'Error',
                nano: 'Error',
              ),
              style: GoogleFonts. poppins(
                fontSize: responsive. fontSize(16),
                fontWeight: FontWeight. w600,
              ),
            ),
            if (responsive.showSecondaryText) ...[
              SizedBox(height: responsive.microPadding),
              Text(
                error,
                style: GoogleFonts. poppins(
                  fontSize: responsive.fontSize(12),
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: responsive.padding),
            ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(
                  responsive.dimension(60),
                  responsive.dimension(36),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(fontSize: responsive.fontSize(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}