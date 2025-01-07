import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/quran_logic.dart';
import '../views/categories/quran/listen_page.dart';
import 'custom_page_transition.dart';

// Converting to StatefulWidget to properly handle async operations
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.055.sw),
          tileColor: const Color(0XFF171715),
          title: Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 0.017.sh,
              color: const Color(0xFFFAFAFA),
            ),
          ),
          trailing: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : SvgPicture.asset(
                  "assets/ui icons/quran_custom_card_backbutton.svg"),
          onTap: _isLoading ? null : _handleSurahsFetch,
        ),
      ),
    );
  }
}
