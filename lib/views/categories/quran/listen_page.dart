import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class Telawah extends StatefulWidget {
  final String title;
  final List<String> surahs;
  final String serverUrl;

  const Telawah({
    super.key,
    required this.title,
    required this.surahs,
    required this.serverUrl,
  });

  @override
  TelawahState createState() => TelawahState();
}

class TelawahState extends State<Telawah> {
  // Add loading state
  bool _isLoading = false;

  // Add error state
  String? _errorMessage;

  // Method to handle loading state
  Future<void> _setLoading(bool loading) async {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  // Enhanced play/pause method with loading state
  Future<void> _playPauseSurah(String surahNumber) async {
    if (_isLoading) return; // Prevent multiple simultaneous requests

    await _setLoading(true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (_currentSurah == surahNumber) {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.resume();
        }
      } else {
        if (_isPlaying) {
          await _audioPlayer.stop();
        }
        final url = '${widget.serverUrl}${surahNumber.padLeft(3, '0')}.mp3';
        await _audioPlayer.play(UrlSource(url));

        if (mounted) {
          setState(() {
            _currentSurah = surahNumber;
            _errorMessage = null; // Clear any previous errors
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to play Surah $surahNumber: $e';
        });
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _playPauseSurah(surahNumber),
            ),
          ),
        );
      }
    } finally {
      await _setLoading(false);
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentSurah;
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;

  static const List<String> suraNames = [
    "الفاتحة",
    "البقرة",
    "آل عمران",
    "النساء",
    "المائدة",
    "الأنعام",
    "الأعراف",
    "الأنفال",
    "التوبة",
    "يونس",
    "هود",
    "يوسف",
    "الرعد",
    "إبراهيم",
    "الحجر",
    "النحل",
    "الإسراء",
    "الكهف",
    "مريم",
    "طه",
    "الأنبياء",
    "الحج",
    "المؤمنون",
    "النور",
    "الفرقان",
    "الشعراء",
    "النمل",
    "القصص",
    "العنكبوت",
    "الروم",
    "لقمان",
    "السجدة",
    "الأحزاب",
    "سبأ",
    "فاطر",
    "يس",
    "الصافات",
    "ص",
    "الزمر",
    "غافر",
    "فصلت",
    "الشورى",
    "الزخرف",
    "الدخان",
    "الجاثية",
    "الأحقاف",
    "محمد",
    "الفتح",
    "الحجرات",
    "ق",
    "الذاريات",
    "الطور",
    "النجم",
    "القمر",
    "الرحمن",
    "الواقعة",
    "الحديد",
    "المجادلة",
    "الحشر",
    "الممتحنة",
    "الصف",
    "الجمعة",
    "المنافقون",
    "التغابن",
    "الطلاق",
    "التحريم",
    "الملك",
    "القلم",
    "الحاقة",
    "المعارج",
    "نوح",
    "الجن",
    "المزمل",
    "المدثر",
    "القيامة",
    "الإنسان",
    "المرسلات",
    "النبأ",
    "النازعات",
    "عبس",
    "التكوير",
    "الإنفطار",
    "المطففين",
    "الإنشقاق",
    "البروج",
    "الطارق",
    "الأعلى",
    "الغاشية",
    "الفجر",
    "البلد",
    "الشمس",
    "الليل",
    "الضحى",
    "الشرح",
    "التين",
    "العلق",
    "القدر",
    "البينة",
    "الزلزلة",
    "العاديات",
    "القارعة",
    "التكاثر",
    "العصر",
    "الهمزة",
    "الفيل",
    "قريش",
    "الماعون",
    "الكوثر",
    "الكافرون",
    "النصر",
    "المسد",
    "الإخلاص",
    "الفلق",
    "الناس"
  ];

  @override
  void initState() {
    super.initState();

    // Listen for duration changes
    _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() {
          _duration = d;
        });
      }
    });

    // Listen for position changes
    _positionSubscription = _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });

    // Listen for state changes
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Listen for completion of playback
    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _position = Duration.zero;
        });
        _playNextSurah();
      }
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Function to format duration into mm:ss
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // Function to play the next Surah
  void _playNextSurah() {
    final currentIndex = widget.surahs.indexOf('Surah $_currentSurah');
    if (currentIndex >= 0 && currentIndex < widget.surahs.length - 1) {
      final nextSurahNumber = widget.surahs[currentIndex + 1].split(' ')[1];
      _playPauseSurah(nextSurahNumber);
    }
  }

  // Function to play the previous Surah
  void _playPreviousSurah() {
    final currentIndex = widget.surahs.indexOf('Surah $_currentSurah');
    if (currentIndex > 0) {
      final prevSurahNumber = widget.surahs[currentIndex - 1].split(' ')[1];
      _playPauseSurah(prevSurahNumber);
    }
  }

  // Build the media control bar
  Widget buildMediaControlBar() {
    final surahIndex = int.tryParse(_currentSurah ?? '') ?? 1;
    final surahName = surahIndex > 0 && surahIndex <= suraNames.length
        ? suraNames[surahIndex - 1]
        : "Surah $_currentSurah";

    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(surahName, style: AppTextSytle.headingsH1),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ),
                onPressed: _playPreviousSurah,
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_currentSurah != null) {
                    _playPauseSurah(_currentSurah!);
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
                onPressed: _playNextSurah,
              ),
              Expanded(
                child: Slider(
                  activeColor: AppColors.primary0,
                  inactiveColor: Colors.grey,
                  min: 0.0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds
                      .toDouble()
                      .clamp(0.0, _duration.inSeconds.toDouble()),
                  onChanged: (double value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                    if (!_isPlaying) {
                      await _audioPlayer.resume();
                    }
                  },
                ),
              ),
              Text(
                '${formatDuration(_position)} / ${formatDuration(_duration)}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrailingIcon(String surahNumber) {
    if (_isLoading && _currentSurah == surahNumber) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary0),
        ),
      );
    }

    if (_currentSurah == surahNumber && _isPlaying) {
      return const Icon(Icons.pause, color: AppColors.primary0);
    }

    return const Icon(Icons.play_arrow, color: AppColors.primary0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.primary1,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 55.h,
        centerTitle: true,
        backgroundColor: AppColors.primary1,
        shadowColor: AppColors.primary1,
        foregroundColor: AppColors.primary1,
        title: Text(widget.title, style: AppTextSytle.headingsH4),
        leading: const SizedBox(width: 0.0),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
                onPressed: () {
                  _audioPlayer.stop();
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 35.w),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content (ListView)
          Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: widget.surahs.length,
              padding: EdgeInsets.only(
                bottom: _isPlaying
                    ? 80.0
                    : 0.0, // Add padding if media control bar is visible
              ),
              itemBuilder: (context, index) {
                final surahNumber = widget.surahs[index].split(' ')[1];
                final surahIndex = int.tryParse(surahNumber) ?? 1;

                // Ensure the surahIndex is within bounds
                final surahName =
                    surahIndex > 0 && surahIndex <= suraNames.length
                        ? suraNames[surahIndex - 1]
                        : "Surah $surahNumber";

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.03.sw, vertical: 0.01.sh),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.055.sw),
                    tileColor: const Color(0XFF171715),
                    title: Text(
                      surahName,
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        fontSize: 0.02.sh,
                        color: const Color(0xFFFAFAFA),
                      ),
                    ),
                    trailing: _buildTrailingIcon(surahNumber),
                    onTap: () {
                      _playPauseSurah(surahNumber);
                    },
                  ),
                );
              },
            ),
          ),
          // Media control bar
          if (_isPlaying && _currentSurah != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildMediaControlBar(),
            ),
        ],
      ),
    );
  }
}
