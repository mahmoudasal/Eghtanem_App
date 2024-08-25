import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'interpretation_json_decoder.dart';

class Faith extends StatefulWidget {
  const Faith({super.key});

  @override
  FaithState createState() => FaithState();
}

class FaithState extends State<Faith> {
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

  List<Interpretation> _getInterpretationsForSura(int suraNumber) {
    return interpretations.where((item) => item.sura == suraNumber).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff1D1D1B),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100.h,
        centerTitle: true,
        backgroundColor: const Color(0xff1D1D1B),
        shadowColor: const Color(0xff1D1D1B),
        foregroundColor: const Color(0xff1D1D1B),
        title: Text(
          "التفسير",
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 25.sp,
            height: 1.2,
            color: const Color(0xFFFAFAFA),
          ),
        ),
        leading: const SizedBox(width: 0.0),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
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
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2, // Adjust this ratio as needed
          ),
          itemCount: suraNames.length, // Number of suras
          itemBuilder: (context, index) {
            final suraNumber = index + 1;
            final suraInterpretations = _getInterpretationsForSura(suraNumber);

            return GestureDetector(
              onTap: () {
                if (suraInterpretations.isNotEmpty) {
                  showModalBottomSheet(
                    backgroundColor: const Color(0xff1D1D1B),
                    context: context,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.builder(
                          itemCount: suraInterpretations.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                'آية ${suraInterpretations[index].aya}',
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              subtitle: Text(
                                suraInterpretations[index].text,
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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
                child: Text(
                  suraNames[index], // Display sura name from the list
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: const Color(0xFFFAFAFA),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
