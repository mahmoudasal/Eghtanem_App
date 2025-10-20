import 'package:eghtanem_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/repositories/quran_repo.dart';
import '../screens/listen_page.dart';
import '../../../../widgets/custom_page_transition.dart';

class ReciterSurahs extends StatefulWidget {
  final String title;
  final String serverUrl;
  final int reciterId;

  const ReciterSurahs({
    super.key,
    required this.title,
    required this.reciterId,
    required this.serverUrl,
  });

  @override
  State<ReciterSurahs> createState() => _ReciterSurahsState();
}

class _ReciterSurahsState extends State<ReciterSurahs> {
  // Loading state indicator
  bool _isLoading = false;

  // Method to handle the fetching of surahs and navigation
  Future<void> _handleSurahsFetch() async {
    // Prevent multiple simultaneous fetches
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the surahs
      final List<String> surahs = await fetchReciterSurahs(widget.reciterId);

      // Check if the widget is still in the tree before proceeding
      if (!mounted) return;

      // Navigate to the Telawah screen
      Navigator.push(
        context,
        createRoute(
          Telawah(
            title: widget.title,
            surahs: surahs,
            serverUrl: widget.serverUrl,
          ),
        ),
      );
    } catch (e) {
      // Check if the widget is still mounted before showing error
      if (!mounted) return;

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load surahs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Reset loading state if widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.055.sw),
          tileColor: Color(0XFF171715),
          title: Text(widget.title, style: AppTextStyles.headingsH5),
          trailing: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(Icons.arrow_forward_ios),
          onTap: _isLoading ? null : _handleSurahsFetch,
        ),
      ),
    );
  }
}
