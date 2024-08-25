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
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseSurah(String surahNumber) async {
    if (_currentSurah == surahNumber && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      final url = '${widget.serverUrl}${surahNumber.padLeft(3, '0')}.mp3';

      try {
        await _audioPlayer.play(UrlSource(url));
        setState(() {
          _currentSurah = surahNumber;
          _isPlaying = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play Surah $surahNumber: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: widget.surahs.length,
          itemBuilder: (context, index) {
            final surahNumber = widget.surahs[index].split(' ')[1];
            final surahIndex = int.tryParse(surahNumber) ?? 1;

            // Ensure the surahIndex is within bounds
            final surahName = surahIndex > 0 && surahIndex <= suraNames.length
                ? suraNames[surahIndex - 1]
                : "Surah $surahNumber";

            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 0.03.sw, vertical: 0.01.sh),
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
                trailing: _currentSurah == surahNumber
                    ? const Icon(
                        Icons.play_arrow,
                        color: Color.fromARGB(255, 182, 151, 115),
                      )
                    : const Icon(
                        Icons.pause,
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
    );
  }
}
