import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/memo_model.dart';
import '../../service/memo_service.dart';
import '../app_colors.dart';

// class MemoCard extends StatelessWidget {
//   final Memo memo;
//   final VoidCallback onTap;
//   final bool isVC;
//
//   const MemoCard({super.key, required this.memo, required this.onTap, required this.isVC});
//
//
//   @override
//   Widget build(BuildContext context) {
//     final MemoService memoService = MemoService();
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 memo.memoTitle,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text('From: ${memo.from}'),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Status: ${memo.status} by VC',
//                     style: TextStyle(
//                       color: memo.status == 'viewed' ? Colors.green : Colors.orange,
//                     ),
//                   ),
//                   if(isVC)
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () => memoService.updateMemoStatus(memo.id, 'viewed'),
//                         child: Icon(
//                           memo.status == 'viewed' ? Icons.bookmark_added_outlined : Icons.visibility_off,
//                           color: memo.status == 'viewed' ? Colors.green : Colors.orange,
//                         ),
//                       ),
//                       memo.status == 'viewed' ? const Text("Read") : const Text("mark as read")
//                     ],
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:intl/intl.dart';

class MemoCard extends StatelessWidget {
  final Memo memo;
  final VoidCallback onTap;
  final bool isVC;

  const MemoCard({
    Key? key,
    required this.memo,
    required this.onTap,
    required this.isVC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MemoService memoService = MemoService();
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      memo.memoTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(theme),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'From: ${memo.from}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    'Date: ${_formatDate(memo.createdAt)}',  // Assuming you have a memo object
                    style: theme.textTheme.bodySmall,
                  ),

                  if (isVC) _buildActionButton(memoService, theme),
                  if (!isVC) _buildCount(memoService, theme),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    final isViewed = memo.status == 'viewed';
    return Chip(
      label: Text(
        isViewed ? 'Viewed' : 'not viewed',
        style: theme.textTheme.labelSmall?.copyWith(
          color: isViewed ? Colors.green.shade700 : Colors.orange.shade700,
        ),
      ),
      backgroundColor: isViewed ? Colors.green.shade50 : Colors.orange.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildActionButton(MemoService memoService, ThemeData theme) {
    final isViewed = memo.status == 'viewed';
    return TextButton.icon(
      onPressed: () => memoService.updateMemoStatus(memo.id, 'viewed'),
      icon: Icon(
        isViewed ? Icons.check_circle_outline : Icons.radio_button_unchecked,
        size: 18,
        color: isViewed ? Colors.green.shade700 : theme.primaryColor,
      ),
      label: Text(
        isViewed ? 'Read' : 'Mark as read',
        style: theme.textTheme.labelSmall?.copyWith(
          color: isViewed ? Colors.green.shade700 : theme.primaryColor,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
      ),
    );
  }

  Widget _buildCount(MemoService memoService, ThemeData theme) {
    final isViewed = memo.status == 'viewed';

    return FutureBuilder<DocumentSnapshot>(
      future: memoService.getMemoById(memo.id), // fetch memo by ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator
        } else if (snapshot.hasError) {
          return const Text('Error'); // Handle error
        } else if (snapshot.hasData) {
          var memoData = snapshot.data!.data() as Map<String, dynamic>;
          int viewCount = memoData['viewCount'] ?? 0;
          String formattedViewCount = formatViewCount(viewCount);

          return TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.visibility,
              size: 18,
              color: isViewed ? Colors.green.shade700 : theme.primaryColor,
            ),
            label: Text(
              '$formattedViewCount views', // Replace the hardcoded value with dynamic viewCount
              style: theme.textTheme.labelSmall?.copyWith(
                color: isViewed ? Colors.green.shade700 : theme.primaryColor,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
            ),
          );
        } else {
          return const Text('No data'); // Handle no data scenario
        }
      },
    );
  }

  String formatViewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return count.toString();
    }
  }
  String _formatDate(DateTime date) {
    // Extract the year, month, and day
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0'); // Add leading zero if necessary
    final day = date.day.toString().padLeft(2, '0');     // Add leading zero if necessary

    // Return the formatted date in yyyy-MM-dd format
    return '$year-$month-$day';
  }

}