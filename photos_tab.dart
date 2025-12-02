import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neat_now/models/employee_models.dart';
import 'package:neat_now/widgets/employee/responsive_employee_helper.dart';

/// EmployeePhotosTab - Displays photo gallery
class EmployeePhotosTab extends StatelessWidget {
  final Future<List<Photo>> photosFuture;
  final VoidCallback onRefresh;
  final EmployeeResponsiveData responsive;

  const EmployeePhotosTab({
    super.key,
    required this.photosFuture,
    required this.onRefresh,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Photo>>(
      future: photosFuture,
      builder: (context, snapshot) {
        if (snapshot. connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
        if (snapshot.hasError) {
          return _buildErrorWidget();
        }
        return _buildPhotosGrid(context, snapshot.data! );
      },
    );
  }

  Widget _buildPhotosGrid(BuildContext context, List<Photo> photos) {
    if (photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment. center,
          children: [
            Icon(
              Icons. photo_library_rounded,
              size: responsive.dimension(60),
              color: Colors.grey[400],
            ),
            SizedBox(height: responsive.padding),
            Text(
              'No photos found',
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
      child: Padding(
        padding: EdgeInsets. all(responsive.padding),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: responsive.gridColumns,
            crossAxisSpacing: responsive.padding,
            mainAxisSpacing: responsive.padding,
            childAspectRatio: responsive.isMicroScreen ?  1.0 : 0.75,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return _buildPhotoCard(context, photos[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context, Photo photo) {
    return Card(
        elevation: responsive.showShadows ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: () => _showPhotoDetail(context, photo),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Image.network(
                        photo.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.broken_image_rounded,
                              size: responsive.dimension(40),
                              color: Colors.grey[500],
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ?  loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: Colors.green,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Info
                  Expanded(
                      flex: responsive.isMicroScreen ? 1 : 2,
                      child: Padding(
                          padding: EdgeInsets. all(responsive.microPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            // Waste type
                            FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment. centerLeft,
                            child: Text(
                              photo. wasteType,
                              style: GoogleFonts.poppins(
                                fontSize: responsive.fontSize(12),
                                fontWeight: FontWeight. w600,
                                color: Colors. black87,
                              ),
                            ),
                          ),

                          if (responsive.showSecondaryText) ...[
                      SizedBox(height: responsive.nanoPadding),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: responsive.iconSize(12),
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: responsive.nanoPadding),
                      Expanded(
                        child: Text(
                          photo.location,
                          style: GoogleFonts.poppins(
                            fontSize: responsive. fontSize(10),
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow. ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],

                if (responsive.showDetailedContent) ...[
            SizedBox(height: responsive.nanoPadding),
        Row(
          children: [
            Icon(
              Icons. person_rounded,
              size: responsive. iconSize(12),
              color: Colors.grey[500],
            ),
            SizedBox(width: responsive.nanoPadding),
            Expanded(
              child: Text(
                photo.uploadedBy,
                style: GoogleFonts.poppins(
                  fontSize: responsive.fontSize(9),
                  color: Colors.grey[500],
                ),
                maxLines: 1,
                overflow: TextOverflow. ellipsis,
              ),
            ),
          ],
        ),
        ],

    // Confidence badge
    if (photo.confidence != null && responsive.showSecondaryText) ...[
    SizedBox(height: responsive.nanoPadding),
    Container(
    padding: EdgeInsets. symmetric(
    horizontal: responsive.nanoPadding,
    vertical: responsive. nanoPadding / 2,
    ),
    decoration: BoxDecoration(
    color: _getConfidenceColor(photo.confidence! ). withOpacity(0.1),
    borderRadius: BorderRadius. circular(4),
    ),
    child: Text(
    'AI: ${(photo.confidence!  * 100).toInt()}%',
    style: GoogleFonts.poppins(
    fontSize: responsive.fontSize(8),
    fontWeight: FontWeight.w600,
    color: _getConfidenceColor(photo.confidence!),
    ),
    ),
    ),
    ],
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return Colors.green;
    if (confidence >= 0.7) return Colors. orange;
    return Colors.red;
  }

  void _showPhotoDetail(BuildContext context, Photo photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.largeBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(responsive. largeBorderRadius),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  photo.imageUrl,
                  fit: BoxFit. cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors. grey[300],
                      child: const Icon(Icons.broken_image_rounded, size: 60),
                    );
                  },
                ),
              ),
            ),

            // Details
            Padding(
              padding: EdgeInsets.all(responsive.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.wasteType,
                    style: GoogleFonts.poppins(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight. bold,
                    ),
                  ),
                  SizedBox(height: responsive.microPadding),
                  _buildDetailRow(Icons.location_on_rounded, photo.location),
                  _buildDetailRow(Icons.person_rounded, photo.uploadedBy),
                  _buildDetailRow(
                    Icons.calendar_today_rounded,
                    _formatDate(photo. uploadDate),
                  ),
                  if (photo.confidence != null)
                    _buildDetailRow(
                      Icons.psychology_rounded,
                      'AI Confidence: ${(photo.confidence! * 100).toInt()}%',
                    ),
                  SizedBox(height: responsive.padding),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius. circular(responsive.borderRadius),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets. symmetric(vertical: responsive.nanoPadding),
      child: Row(
        children: [
          Icon(icon, size: responsive.iconSize(16), color: Colors.grey[600]),
          SizedBox(width: responsive.microPadding),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: responsive.fontSize(12),
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildErrorWidget() {
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
            'Error loading photos',
            style: GoogleFonts. poppins(
              fontSize: responsive. fontSize(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsive.padding),
          ElevatedButton(
            onPressed: onRefresh,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}