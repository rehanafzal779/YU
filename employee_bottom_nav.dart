import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neat_now/widgets/employee/responsive_employee_helper.dart';

/// EmployeeBottomNavExtended - Bottom navigation with profile picture
class EmployeeBottomNavExtended extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final EmployeeResponsiveData responsive;
  final String?  profileImageUrl;
  final String userName;

  const EmployeeBottomNavExtended({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this. responsive,
    this.profileImageUrl,
    required this. userName,
  });

  static const List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard', 'short': 'Home', 'micro': '🏠'},
    {'icon': Icons. assignment_rounded, 'label': 'Reports', 'short': 'Rpts', 'micro': '📋'},
    {'icon': Icons.people_rounded, 'label': 'Users', 'short': 'Usr', 'micro': '👥'},
    {'icon': Icons. analytics_rounded, 'label': 'Analytics', 'short': 'Ana', 'micro': '📊'},
    {'icon': Icons.photo_library_rounded, 'label': 'Photos', 'short': 'Pic', 'micro': '🖼️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors. white,
        boxShadow: responsive.showShadows
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ]
            : [],
      ),
      child: SafeArea(
        child: Container(
          height: responsive.isMicroScreen
              ? 50
              : responsive.isTinyScreen
              ?  55
              : responsive.dimension(70),
          padding: EdgeInsets. symmetric(
            horizontal: responsive. microPadding,
            vertical: responsive.nanoPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Regular nav items
              ... List.generate(_navItems.length, (index) {
                return Expanded(
                  child: _buildNavItem(
                    _navItems[index]['icon'] as IconData,
                    _navItems[index]['label'] as String,
                    _navItems[index]['short'] as String,
                    _navItems[index]['micro'] as String,
                    index,
                  ),
                );
              }),
              // Profile nav item with picture
              Expanded(
                child: _buildProfileNavItem(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon,
      String label,
      String shortLabel,
      String microLabel,
      int index,
      ) {
    final isSelected = selectedIndex == index;

    String displayLabel;
    if (responsive.isMicroScreen) {
      displayLabel = '';
    } else if (responsive.isTinyScreen) {
      displayLabel = shortLabel;
    } else {
      displayLabel = label;
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTabSelected(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets. symmetric(
          horizontal: responsive.nanoPadding,
          vertical: responsive. nanoPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors. green.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(responsive.borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (responsive.isMicroScreen)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  microLabel,
                  style: TextStyle(
                    fontSize: responsive.fontSize(16),
                    color: isSelected ? Colors.green : Colors.grey,
                  ),
                ),
              )
            else
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets. all(isSelected ? responsive.nanoPadding : 0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors. green.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius. circular(responsive.borderRadius),
                ),
                child: Icon(
                  icon,
                  size: responsive.iconSize(20),
                  color: isSelected ? Colors.green : Colors. grey,
                ),
              ),
            if (displayLabel.isNotEmpty) ...[
              SizedBox(height: responsive.nanoPadding),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    displayLabel,
                    style: GoogleFonts. poppins(
                      fontSize: responsive.fontSize(9),
                      fontWeight: isSelected ? FontWeight. w600 : FontWeight.w500,
                      color: isSelected ?  Colors.green : Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileNavItem() {
    final isSelected = selectedIndex == 5; // Profile tab index
    final avatarSize = responsive. isMicroScreen
        ? 24.0
        : responsive.isTinyScreen
    ? 28.0
        : responsive.dimension(32);

    return GestureDetector(
    onTap: () {
    HapticFeedback.selectionClick();
    onTabSelected(5);
    },
    child: AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    padding: EdgeInsets.symmetric(
    horizontal: responsive.nanoPadding,
    vertical: responsive.nanoPadding,
    ),
    decoration: BoxDecoration(
    color: isSelected ? Colors.green. withOpacity(0.1) : Colors.transparent,
    borderRadius: BorderRadius.circular(responsive. borderRadius),
    ),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    // Profile picture or avatar
    Container(
    width: avatarSize,
    height: avatarSize,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
    color: isSelected ? Colors.green : Colors.grey. withOpacity(0.5),
    width: isSelected ? 2 : 1.5,
    ),
    boxShadow: isSelected
    ?  [
    BoxShadow(
    color: Colors.green.withOpacity(0.3),
    blurRadius: 6,
    ),
    ]
        : [],
    ),
    child: ClipOval(
    child: _buildProfileImage(avatarSize),
    ),
    ),
    if (! responsive.isMicroScreen) ...[
    SizedBox(height: responsive.nanoPadding),
    Flexible(
    child: FittedBox(
    fit: BoxFit. scaleDown,
    child: Text(
    responsive.isTinyScreen ?  'Me' : 'Profile',
    style: GoogleFonts.poppins(
    fontSize: responsive.fontSize(9),
    fontWeight: isSelected ?  FontWeight.w600 : FontWeight. w500,
    color: isSelected ?  Colors.green : Colors.grey,
    ),
    maxLines: 1,
    overflow: TextOverflow. ellipsis,
    ),
    ),
    ),
    ],
    ],
    ),
    ),
    );
  }

  Widget _buildProfileImage(double size) {
    if (profileImageUrl != null && profileImageUrl!. isNotEmpty) {
      return Image.network(
        profileImageUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(size),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            color: Colors.grey[200],
            child: Center(
              child: SizedBox(
                width: size * 0.5,
                height: size * 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ?  loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      );
    }

    return _buildDefaultAvatar(size);
  }

  Widget _buildDefaultAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        ),
      ),
      child: Center(
        child: Text(
          userName. isNotEmpty ?  userName[0]. toUpperCase() : 'E',
          style: GoogleFonts.poppins(
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}