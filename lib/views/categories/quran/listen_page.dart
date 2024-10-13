import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_svg/flutter_svg.dart';

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

  // Function to play or pause a Surah
  void _playPauseSurah(String surahNumber) async {
    if (_currentSurah == surahNumber) {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } else {
      // Stop current Surah if different
      if (_isPlaying) {
        await _audioPlayer.stop();
      }
      final url = '${widget.serverUrl}${surahNumber.padLeft(3, '0')}.mp3';
      try {
        await _audioPlayer.play(UrlSource(url));
        setState(() {
          _currentSurah = surahNumber;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play Surah $surahNumber: $e')),
        );
      }
    }
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
          Text(
            surahName,
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFFFAFAFA),
            ),
          ),
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
                  activeColor: const Color.fromARGB(255, 182, 151, 115),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xff1D1D1B),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 55.h,
        centerTitle: true,
        backgroundColor: const Color(0xff1D1D1B),
        shadowColor: const Color(0xff1D1D1B),
        foregroundColor: const Color(0xff1D1D1B),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFFFAFAFA),
          ),
        ),
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
                    trailing: (_currentSurah == surahNumber && _isPlaying)
                        ? const Icon(
                            Icons.pause,
                            color: Color.fromARGB(255, 182, 151, 115),
                          )
                        : const Icon(
                            Icons.play_arrow,
                            color: Color.fromARGB(255, 182, 151, 115),
                          ),
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
