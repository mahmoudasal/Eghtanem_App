import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/tafseer_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class Tafseer extends StatefulWidget {
  const Tafseer({super.key});

  @override
  TafseerState createState() => TafseerState();
}

class TafseerState extends State<Tafseer> {
  final List<String> suraNames = const [
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

  List<Interpretation> interpretations = [];

  @override
  void initState() {
    super.initState();
    _loadInterpretations();
  }

  Future<void> _loadInterpretations() async {
    final String response =
        await rootBundle.loadString('assets/quran_metadata/ar_ma3any.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      interpretations =
          data.map((item) => Interpretation.fromJson(item)).toList();
    });
  }

  // Function to convert numbers to Arabic-Indic numerals
  String convertToArabicNumeral(int number) {
    const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumerals[int.parse(digit)])
        .join();
  }

  // Updated function to filter out interpretations with empty 'text'
  List<Interpretation> _getInterpretationsForSura(int suraNumber) {
    return interpretations
        .where((item) => item.sura == suraNumber && item.text.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primary1,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100.h,
        centerTitle: true,
        backgroundColor: AppColors.primary1,
        shadowColor: AppColors.primary1,
        foregroundColor: AppColors.primary1,
        title: Text("التفسير", style: AppTextStyles.headingsH1),
        leading: const SizedBox(width: 0.0),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/icons/BackButton.svg"),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(
                width: 35.w,
              ),
            ],
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2, 
          ),
          itemCount: suraNames.length, 
          itemBuilder: (context, index) {
            final suraNumber = index + 1;
            final suraInterpretations = _getInterpretationsForSura(suraNumber);

            return GestureDetector(
              onTap: () {
                if (suraInterpretations.isNotEmpty) {
                  showModalBottomSheet(
                    backgroundColor: AppColors.primary1,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handlebar
                        Container(
                          width: 40.w,
                          height: 5.h,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // Surah Title
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(suraNames[index],
                              style: AppTextStyles.headingsH2),
                        ),
                        // Interpretations List
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListView.builder(
                              itemCount: suraInterpretations.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      'الايه ${convertToArabicNumeral(suraInterpretations[index].aya)}',
                                      style: AppTextStyles.headingsH4),
                                  subtitle: Text(
                                      suraInterpretations[index].text,
                                      style: AppTextStyles.headingsH5
                                          .copyWith(height: 1.8)),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 46, 46, 46),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(suraNames[index], // Display sura name and number
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingsH5),
              ),
            );
          },
        ),
      ),
    );
  }
}
