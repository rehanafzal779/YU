import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neat_now/services/auth_service.dart';
import 'package:neat_now/services/employee_service.dart';
import 'package:neat_now/widgets/employee/responsive_employee_helper.dart';
import 'package:neat_now/screens/employee_profile_screen.dart';

/// EmployeeProfileTab - Profile overview and settings for workers
/// Implements FR-W2: Worker profile management
class EmployeeProfileTab extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> employeeStats;
  final bool isDemoMode;
  final VoidCallback onLogout;
  final VoidCallback onProfileUpdate;
  final EmployeeResponsiveData responsive;

  const EmployeeProfileTab({
    super.key,
    required this.userData,
    required this. employeeStats,
    required this.isDemoMode,
    required this.onLogout,
    required this.onProfileUpdate,
    required this.responsive,
  });

  @override
  State<EmployeeProfileTab> createState() => _EmployeeProfileTabState();
}

class _EmployeeProfileTabState extends State<EmployeeProfileTab> {
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _isAvailable = widget.userData['is_available'] ??
        widget.userData['isAvailable'] ??  true;
  }

  Future<void> _toggleAvailability(bool value) async {
    HapticFeedback.selectionClick();
    setState(() => _isAvailable = value);

    final success = await EmployeeService.updateAvailability(value);
    if (! success && mounted) {
      setState(() => _isAvailable = ! value);
      ScaffoldMessenger.of(context). showSnackBar(
        SnackBar(
          content: const Text('Failed to update availability'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius. circular(10)),
        ),
      );
    }
  }

  void _navigateToFullProfile() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeProfileScreen(),
      ),
    ). then((_) => widget.onProfileUpdate());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(widget.responsive.padding),
            child: Column(
              children: [
                _buildProfileHeader(),
                SizedBox(height: widget.responsive.largePadding),
                _buildStatsOverview(),
                SizedBox(height: widget.responsive.largePadding),
                _buildAvailabilityCard(),
                SizedBox(height: widget.responsive.largePadding),
                _buildQuickActions(),
                SizedBox(height: widget.responsive. largePadding),
                _buildSettingsSection(),
                SizedBox(height: widget.responsive.largePadding),
                _buildLogoutButton(),
                SizedBox(height: widget.responsive.dimension(100)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
        expandedHeight: widget.responsive.isMicroScreen
            ? 60.0
        : widget.responsive.isTinyScreen
    ?  80.0
        : widget.responsive.dimension(140) + widget.responsive.safePaddingTop,
    pinned: true,
    backgroundColor: const Color(0xFF1B5E20),
    automaticallyImplyLeading: false,
    flexibleSpace: FlexibleSpaceBar(
    background: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
    Color(0xFF0A3D2C),
    Color(0xFF1B5E20),
    Color(0xFF2E7D32),
    ],
    ),
    ),
    child: SafeArea(
    child: Padding(
    padding: EdgeInsets. all(widget.responsive.padding),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Expanded(
    child: FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment.centerLeft,
    child: Text(
    widget.responsive.adaptiveText(
    'My Profile',
    micro: '👤',
    nano: 'Me',
    mini: 'Profile',
    ),
    style: GoogleFonts.poppins(
    fontSize: widget.responsive.fontSize(24),
    fontWeight: FontWeight. bold,
    color: Colors.white,
    ),
    ),
    ),
    ),
    if (widget.isDemoMode)
    Container(
    padding: EdgeInsets. symmetric(
    horizontal: widget.responsive.microPadding,
    vertical: widget.responsive.nanoPadding,
    ),
    decoration: BoxDecoration(
    color: Colors.orange. withOpacity(0.2),
    borderRadius: BorderRadius. circular(widget.responsive.borderRadius),
    ),
    child: Text(
    '🔧',
    style: TextStyle(fontSize: widget.responsive. fontSize(12)),
    ),
    ),
    ],
    ),
    if (widget. responsive.showSecondaryText) ...[
    SizedBox(height: widget.responsive.microPadding),
    FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment. centerLeft,
    child: Text(
    'Manage your account & settings',
    style: GoogleFonts.poppins(
    fontSize: widget.responsive. fontSize(12),
    color: Colors.white. withOpacity(0.9),
    ),
    ),
    ),
    ],
    ],
    ),
    ),
    ),
    ),
    ),
    );
  }

  Widget _buildProfileHeader() {
    return GestureDetector(
        onTap: _navigateToFullProfile,
        child: Container(
          padding: EdgeInsets. all(widget.responsive.padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.responsive.largeBorderRadius),
            boxShadow: widget.responsive.showShadows
                ?  [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Row(
              children: [
          // Avatar
          Container(
          width: widget.responsive. dimension(80),
          height: widget.responsive.dimension(80),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
            ),
            shape: BoxShape.circle,
            boxShadow: widget.responsive.showShadows
                ? [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Center(
            child: Text(
              (widget.userData['name'] ?? 'E'). toString(). isNotEmpty
                  ? widget.userData['name']. toString()[0].toUpperCase()
                  : 'E',
              style: GoogleFonts.poppins(
                fontSize: widget. responsive.fontSize(32),
                fontWeight: FontWeight. bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(width: widget.responsive.padding),

        // Info
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.userData['name'] ?? 'Employee',
                style: GoogleFonts. poppins(
                  fontSize: widget.responsive.fontSize(18),
                  fontWeight: FontWeight. bold,
                  color: Colors.black87,
                ),
              ),
            ),
            if (widget.responsive.showSecondaryText) ...[
    SizedBox(height: widget.responsive. nanoPadding),
    Text(
    widget.userData['email'] ?? '',
    style: GoogleFonts. poppins(
    fontSize: widget.responsive.fontSize(12),
    color: Colors.grey[600],
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
    ],
    SizedBox(height: widget.responsive.microPadding),
    Row(
    children: [
    Container(
    padding: EdgeInsets. symmetric(
    horizontal: widget.responsive. microPadding,
    vertical: widget.responsive.nanoPadding,
    ),
    decoration: BoxDecoration(
    color: Colors.green.withOpacity(0.1),
    borderRadius: BorderRadius.circular(widget.responsive.borderRadius),
    ),
    child: Row(
    mainAxisSize: MainAxisSize. min,
    children: [
    Icon(
    Icons.work_rounded,
    size: widget.responsive. iconSize(12),
    color: Colors.green,
    ),
    SizedBox(width: widget.responsive.nanoPadding),
    Text(
    widget.userData['role'] ?? 'Field Worker',
    style: GoogleFonts.poppins(
    fontSize: widget.responsive. fontSize(10),
    fontWeight: FontWeight. w600,
    color: Colors.green,
    ),
    ),
    ],
    ),
    ),
    SizedBox(width: widget.responsive. microPadding),
    Container(
    width: widget.responsive. dimension(8),
    height: widget.responsive. dimension(8),
    decoration: BoxDecoration(
    color: _isAvailable ? Colors.green : Colors.red,
    shape: BoxShape.circle,
    ),
    ),
    ],
    ),
    ],
    ),
    ),

    // Edit button
    Container(
    padding: EdgeInsets.all(widget.responsive. microPadding),
    decoration: BoxDecoration(
    color: Colors.grey. withOpacity(0.1),
    borderRadius: BorderRadius. circular(widget.responsive.borderRadius),
    ),
    child: Icon(
    Icons. arrow_forward_ios_rounded,
    size: widget.responsive. iconSize(16),
    color: Colors.grey[600],
    ),
    ),
    ],
    ),
    ),
    );
    }

  Widget _buildStatsOverview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget. responsive.largeBorderRadius),
        boxShadow: widget.responsive.showShadows
            ?  [
          BoxShadow(
            color: Colors. black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Padding(
        padding: EdgeInsets. all(widget.responsive.padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.assignment_turned_in_rounded,
              value: widget.employeeStats['resolved_reports']?. toString() ??
                  widget.employeeStats['resolvedReports']?. toString() ??
                  '0',
              label: 'Resolved',
              color: Colors.green,
            ),
            _buildStatDivider(),
            _buildStatItem(
              icon: Icons.pending_actions_rounded,
              value: widget.employeeStats['pending_reports']?.toString() ??
                  widget.employeeStats['pendingReports']?.toString() ??
                  '0',
              label: 'Pending',
              color: Colors.orange,
            ),
            _buildStatDivider(),
            _buildStatItem(
              icon: Icons.star_rounded,
              value: (widget.userData['rating'] ?? 4.8).toString(),
              label: 'Rating',
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(widget.responsive. microPadding),
            decoration: BoxDecoration(
              color: color. withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: widget.responsive.iconSize(22),
            ),
          ),
          SizedBox(height: widget.responsive.microPadding),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts. poppins(
                fontSize: widget. responsive.fontSize(20),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            widget.responsive.adaptiveText(
              label,
              micro: label.substring(0, 1),
              nano: label.substring(0, 3),
            ),
            style: GoogleFonts.poppins(
              fontSize: widget.responsive. fontSize(11),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: widget.responsive. dimension(50),
      color: Colors.grey. withOpacity(0.2),
    );
  }

  Widget _buildAvailabilityCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isAvailable
              ? [Colors.green. shade400, Colors.green. shade600]
              : [Colors.red.shade400, Colors.red.shade600],
        ),
        borderRadius: BorderRadius. circular(widget.responsive.largeBorderRadius),
        boxShadow: widget.responsive.showShadows
            ? [
          BoxShadow(
            color: (_isAvailable ?  Colors.green : Colors.red).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.responsive.padding),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets. all(widget.responsive.microPadding),
              decoration: BoxDecoration(
                color: Colors.white. withOpacity(0.2),
                borderRadius: BorderRadius.circular(widget.responsive. borderRadius),
              ),
              child: Icon(
                _isAvailable ? Icons.check_circle_rounded : Icons. cancel_rounded,
                color: Colors.white,
                size: widget.responsive.iconSize(28),
              ),
            ),
            SizedBox(width: widget.responsive.padding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isAvailable ? 'Available for Tasks' : 'Currently Unavailable',
                    style: GoogleFonts.poppins(
                      fontSize: widget.responsive. fontSize(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.responsive.showSecondaryText)
                    Text(
                      _isAvailable
                          ? 'You can receive new task assignments'
                          : 'You won\'t receive new task assignments',
                      style: GoogleFonts.poppins(
                        fontSize: widget.responsive. fontSize(11),
                        color: Colors.white. withOpacity(0.9),
                      ),
                    ),
                ],
              ),
            ),
            Transform.scale(
              scale: widget.responsive.isMicroScreen ? 0.8 : 1.0,
              child: Switch(
                value: _isAvailable,
                onChanged: _toggleAvailability,
                activeColor: Colors. white,
                activeTrackColor: Colors. white.withOpacity(0.5),
                inactiveThumbColor: Colors. white,
                inactiveTrackColor: Colors.white.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget. responsive.largeBorderRadius),
        boxShadow: widget.responsive.showShadows
            ?  [
          BoxShadow(
            color: Colors. black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Column(
        children: [
          _buildActionItem(
            icon: Icons.edit_rounded,
            title: 'Edit Profile',
            subtitle: 'Update your information & photo',
            onTap: _navigateToFullProfile,
          ),
          Divider(height: 1, color: Colors.grey. withOpacity(0.2)),
          _buildActionItem(
            icon: Icons.lock_rounded,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () => _showComingSoon('Change Password'),
          ),
          Divider(height: 1, color: Colors. grey.withOpacity(0.2)),
          _buildActionItem(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () => _showComingSoon('Notifications'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Padding(
          padding: EdgeInsets. all(widget.responsive.padding),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets. all(widget.responsive.microPadding),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(widget.responsive.borderRadius),
                ),
                child: Icon(
                  icon,
                  color: Colors.green,
                  size: widget.responsive.iconSize(22),
                ),
              ),
              SizedBox(width: widget.responsive.padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: widget.responsive.fontSize(14),
                        fontWeight: FontWeight. w600,
                        color: Colors. black87,
                      ),
                    ),
                    if (widget.responsive. showSecondaryText)
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: widget.responsive.fontSize(11),
                          color: Colors. grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: widget. responsive.iconSize(16),
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget. responsive.largeBorderRadius),
        boxShadow: widget.responsive.showShadows
            ?  [
          BoxShadow(
            color: Colors. black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons. language_rounded,
            title: 'Language',
            value: 'English',
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          _buildSettingsItem(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            trailing: Transform.scale(
              scale: widget.responsive.isMicroScreen ? 0.7 : 0.9,
              child: Switch(
                value: false,
                onChanged: (value) => _showComingSoon('Dark Mode'),
                activeColor: Colors.green,
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey. withOpacity(0.2)),
          _buildActionItem(
            icon: Icons.info_rounded,
            title: 'About',
            subtitle: 'App version 1.0. 0',
            onTap: () => _showAboutDialog(),
          ),
          Divider(height: 1, color: Colors.grey. withOpacity(0.2)),
          _buildActionItem(
            icon: Icons.help_rounded,
            title: 'Help & Support',
            subtitle: 'Get help or contact us',
            onTap: () => _showComingSoon('Help & Support'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? value,
    Widget? trailing,
  }) {
    return Padding(
      padding: EdgeInsets.all(widget. responsive.padding),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(widget.responsive. microPadding),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(widget.responsive.borderRadius),
            ),
            child: Icon(
              icon,
              color: Colors. green,
              size: widget.responsive. iconSize(22),
            ),
          ),
          SizedBox(width: widget.responsive.padding),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: widget.responsive.fontSize(14),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          if (trailing != null)
            trailing
          else if (value != null)
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: widget.responsive.fontSize(13),
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red. withOpacity(0.1),
        borderRadius: BorderRadius. circular(widget.responsive.largeBorderRadius),
        border: Border.all(color: Colors.red. withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLogoutDialog(),
          borderRadius: BorderRadius. circular(widget.responsive.largeBorderRadius),
          child: Padding(
            padding: EdgeInsets. all(widget.responsive.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons. logout_rounded,
                  color: Colors.red,
                  size: widget.responsive.iconSize(22),
                ),
                SizedBox(width: widget.responsive.microPadding),
                Text(
                  'Logout',
                  style: GoogleFonts. poppins(
                    fontSize: widget.responsive.fontSize(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger. of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon! '),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius. circular(10)),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.responsive.largeBorderRadius),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets. all(widget.responsive.microPadding),
              decoration: BoxDecoration(
                color: Colors. green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(widget.responsive.borderRadius),
              ),
              child: Icon(Icons.eco_rounded, color: Colors. green),
            ),
            SizedBox(width: widget. responsive.microPadding),
            Text('Neat Now', style: GoogleFonts.poppins(fontWeight: FontWeight. bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI-Powered Waste Detection',
              style: GoogleFonts. poppins(fontWeight: FontWeight. w600),
            ),
            SizedBox(height: widget. responsive.microPadding),
            Text(
              'Version 1.0. 0\n\nHelping communities track and manage waste efficiently using AI detection technology.',
              style: GoogleFonts. poppins(fontSize: widget.responsive. fontSize(13)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius. circular(widget.responsive.largeBorderRadius),
        ),
        title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onLogout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}