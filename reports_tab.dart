import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neat_now/models/employee_models.dart';
import 'package:neat_now/widgets/employee/responsive_employee_helper.dart';

/// EmployeeReportsTab - Displays and manages reports
/// Implements FR-W3, FR-W4, FR-W5
class EmployeeReportsTab extends StatelessWidget {
  final Future<List<Report>> reportsFuture;
  final Function(int, String) onUpdateStatus;
  final VoidCallback onRefresh;
  final EmployeeResponsiveData responsive;

  const EmployeeReportsTab({
    super.key,
    required this.reportsFuture,
    required this.onUpdateStatus,
    required this.onRefresh,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Report>>(
      future: reportsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState. waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        }
        if (snapshot.hasError) {
          return _buildErrorWidget(context, snapshot.error.toString());
        }
        return _buildReportsList(context, snapshot.data! );
      },
    );
  }

  Widget _buildReportsList(BuildContext context, List<Report> reports) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_rounded,
              size: responsive.dimension(60),
              color: Colors.grey[400],
            ),
            SizedBox(height: responsive.padding),
            Text(
              'No reports found',
              style: GoogleFonts.poppins(
                fontSize: responsive.fontSize(16),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: Colors.green,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets. all(responsive.padding),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return _buildReportCard(context, reports[index]);
        },
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report) {
    Color statusColor;
    String statusText;

    switch (report.status) {
      case 'resolved':
        statusColor = Colors.green;
        statusText = responsive.adaptiveText('Resolved', micro: 'OK', nano: 'Done');
        break;
      case 'in-progress':
        statusColor = Colors.blue;
        statusText = responsive.adaptiveText('In Progress', micro: 'IP', nano: 'WIP');
        break;
      default:
        statusColor = Colors.orange;
        statusText = responsive.adaptiveText('Pending', micro: 'PD', nano: 'Pend');
    }

    return Card(
      margin: EdgeInsets. only(bottom: responsive.padding),
      elevation: responsive.showShadows ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.padding),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        // Header row
        Row(
        children: [
        // Type icon
        Container(
        padding: EdgeInsets. all(responsive.microPadding),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(responsive.borderRadius),
        ),
        child: Icon(
          _getReportIcon(report.type),
          color: statusColor,
          size: responsive. iconSize(20),
        ),
      ),
      SizedBox(width: responsive.padding),

      // Title
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment. start,
          children: [
            Text(
              report.type,
              style: GoogleFonts.poppins(
                fontSize: responsive.fontSize(16),
                fontWeight: FontWeight. bold,
              ),
              maxLines: 1,
              overflow: TextOverflow. ellipsis,
            ),
            if (responsive.showSecondaryText)
              Text(
                'ID: #${report.id}',
                style: GoogleFonts.poppins(
                  fontSize: responsive.fontSize(10),
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      ),

      // Status badge
      Container(
        padding: EdgeInsets. symmetric(
          horizontal: responsive.microPadding,
          vertical: responsive.nanoPadding,
        ),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(responsive. borderRadius),
        ),
        child: Text(
          statusText,
          style: GoogleFonts.poppins(
            fontSize: responsive.fontSize(10),
            fontWeight: FontWeight. w600,
            color: statusColor,
          ),
        ),
      ),
      ],
    ),

    // Details
    if (responsive.showSecondaryText) ...[
    SizedBox(height: responsive.padding),

    // Location
    Row(
    children: [
    Icon(
    Icons.location_on_rounded,
    size: responsive.iconSize(16),
    color: Colors.grey[500],
    ),
    SizedBox(width: responsive.microPadding),
    Expanded(
    child: Text(
    report.location,
    style: GoogleFonts.poppins(
    fontSize: responsive.fontSize(12),
    color: Colors.grey[600],
    ),
    maxLines: 1,
    overflow: TextOverflow. ellipsis,
    ),
    ),
    ],
    ),
    SizedBox(height: responsive.microPadding),

    // User
    Row(
    children: [
    Icon(
    Icons.person_rounded,
    size: responsive.iconSize(16),
    color: Colors.grey[500],
    ),
    SizedBox(width: responsive. microPadding),
    Expanded(
    child: Text(
    report.userName,
    style: GoogleFonts.poppins(
    fontSize: responsive.fontSize(12),
    color: Colors.grey[600],
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
    ),
    ],
    ),
    SizedBox(height: responsive.microPadding),

    // Date
    Row(
    children: [
    Icon(
    Icons.calendar_today_rounded,
    size: responsive. iconSize(16),
    color: Colors.grey[500],
    ),
    SizedBox(width: responsive.microPadding),
    Text(
    _formatDate(report. date),
    style: GoogleFonts.poppins(
    fontSize: responsive.fontSize(12),
    color: Colors.grey[600],
    ),
    ),
    ],
    ),
    ],

    // Action buttons for pending reports
    if (report.status == 'pending') ...[
    SizedBox(height: responsive.padding),
    _buildActionButtons(context, report),
    ],
    ],
    ),
    ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Report report) {
    if (responsive.isMicroScreen || responsive.isTinyScreen) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton. icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onUpdateStatus(report.id, 'in-progress');
              },
              icon: Icon(Icons.play_arrow_rounded, size: responsive.iconSize(18)),
              label: Text(
                responsive.adaptiveText('Start', micro: '▶', nano: 'Start'),
                style: TextStyle(fontSize: responsive.fontSize(12)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors. white,
                minimumSize: Size(0, responsive.dimension(36)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive. borderRadius),
                ),
              ),
            ),
          ),
          SizedBox(height: responsive.microPadding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton. icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onUpdateStatus(report.id, 'resolved');
              },
              icon: Icon(Icons.check_rounded, size: responsive. iconSize(18)),
              label: Text(
                responsive. adaptiveText('Resolve', micro: '✓', nano: 'Done'),
                style: TextStyle(fontSize: responsive.fontSize(12)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(0, responsive.dimension(36)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.borderRadius),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onUpdateStatus(report.id, 'in-progress');
            },
            icon: Icon(Icons.play_arrow_rounded, size: responsive.iconSize(18)),
            label: Text(
              'Start Processing',
              style: TextStyle(fontSize: responsive.fontSize(12)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(0, responsive.dimension(40)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.borderRadius),
              ),
            ),
          ),
        ),
        SizedBox(width: responsive.padding),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onUpdateStatus(report.id, 'resolved');
            },
            icon: Icon(Icons. check_rounded, size: responsive.iconSize(18)),
            label: Text(
              'Mark Resolved',
              style: TextStyle(fontSize: responsive.fontSize(12)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: Size(0, responsive.dimension(40)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.borderRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getReportIcon(String type) {
    switch (type. toLowerCase()) {
      case 'plastic waste':
        return Icons.local_drink_rounded;
      case 'organic waste':
        return Icons.eco_rounded;
      case 'electronic waste':
        return Icons.devices_rounded;
      case 'hazardous waste':
        return Icons.warning_rounded;
      default:
        return Icons.delete_rounded;
    }
  }

  String _formatDate(DateTime date) {
    if (responsive.isMicroScreen) {
      return '${date.day}/${date.month}';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(responsive.padding),
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
              'Error loading reports',
              style: GoogleFonts.poppins(
                fontSize: responsive.fontSize(16),
                fontWeight: FontWeight. w600,
              ),
            ),
            SizedBox(height: responsive.padding),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}