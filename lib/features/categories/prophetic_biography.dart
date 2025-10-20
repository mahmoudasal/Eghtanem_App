import 'package:eghtanem_app/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PropheticBiography extends StatefulWidget {
  const PropheticBiography({super.key});

  @override
  PropheticBiographyState createState() => PropheticBiographyState();
}

class PropheticBiographyState extends State<PropheticBiography> {
  final List<Map<String, String>> videos = const [
    {
      "title": "الدرس الأول- العالم قبل الإسلام",
      "url": "https://www.youtube.com/watch?v=LI99lWP1zac"
    },
    {
      "title": "الدرس الثاني- مولد النبي وبداية شبابه",
      "url": "https://www.youtube.com/watch?v=A6_y0HuwSQw"
    },
    {
      "title":
          "الدرس الثالث الجزء الأول- وصف النبي صلي الله عليه وسلم وزواجه من السيدة خديجة",
      "url": "https://www.youtube.com/watch?v=nqpVIANGU-o"
    },
    {
      "title":
          "الدرس الثالث الجزء الثاني- وصف النبي صلي الله عليه وسلم وزواجه من السيدة خديجة",
      "url": "https://www.youtube.com/watch?v=YdWK45slrqc"
    },
    {
      "title": "الدرس الرابع- نزول الوحي علي النبي والدعوة السرية بمكة",
      "url": "https://www.youtube.com/watch?v=6SiKw-qQ6mk"
    },
    {
      "title": "الدرس الخامس- بداية الجهر بالدعوة",
      "url": "https://www.youtube.com/watch?v=GLvr-pYGLOs"
    },
    {
      "title":
          "الدرس السادس- بداية فترة استضعاف المسلمين في مكة والهجرة إلى الحبشة",
      "url": "https://www.youtube.com/watch?v=aliwSuClQRI"
    },
    {
      "title": "الدرس السابع- إسلام عمر بن الخطاب ووفاة أبو طالب عم النبي",
      "url": "https://www.youtube.com/watch?v=dZ1EkPuj91w"
    },
    {
      "title":
          "الدرس الثامن- عام الحزن ورحلة النبي صلي الله عليه وسلم إلى الطائف",
      "url": "https://www.youtube.com/watch?v=Tl1NmCYk1G4"
    },
    {
      "title": "الدرس التاسع- رحلة الإسراء والمعراج",
      "url": "https://www.youtube.com/watch?v=mvwhozvTKd8"
    },
    {
      "title": "الدرس العاشر- الطواف علي القبائل وبيعة العقبة الأولي",
      "url": "https://www.youtube.com/watch?v=SlBo6bmtuTI"
    },
    {
      "title": "الدرس الحادي عشر- أحداث الهجرة إلى المدينة",
      "url": "https://www.youtube.com/watch?v=GGFse7G6cAs"
    },
    {
      "title": "الدرس الثاني عشر- بداية العهد المدني وتأسيس مدينة المسلمين",
      "url": "https://www.youtube.com/watch?v=3rzbyI2_cvc"
    },
    {
      "title": "الدرس الثالث عشر- مجتمع المدينة ومفهوم الجهاد في سبيل الله",
      "url": "https://www.youtube.com/watch?v=7spRnIahHk4"
    },
    {
      "title": "الدرس الرابع عشر- غزوة بدر",
      "url": "https://www.youtube.com/watch?v=b7YVYhcQdfU"
    },
    {
      "title": "الدرس الخامس عشر- أحداث ما بين بدر وأحد",
      "url": "https://www.youtube.com/watch?v=Pt2EEsFtf5Y"
    },
    {
      "title": "الدرس السادس عشر- غزوة أحد",
      "url": "https://www.youtube.com/watch?v=EWvAT3HcUic"
    },
    {
      "title": "الدرس السابع عشر- حادثة الإفك",
      "url": "https://www.youtube.com/watch?v=2XJ1102-9rg"
    },
    {
      "title": "الدرس الثامن عشر- غزوة الخندق",
      "url": "https://www.youtube.com/watch?v=XPql-o9tQ0s"
    },
    {
      "title": "الدرس التاسع عشر- صلح الحديبية",
      "url": "https://www.youtube.com/watch?v=mbsTyEaQmJY"
    },
    {
      "title": "الدرس العشرون- غزوة خيبر",
      "url": "https://www.youtube.com/watch?v=3MF0xKJ2DWo"
    },
    {
      "title": "الدرس الواحد والعشرون- أحداث ما قبل فتح مكة",
      "url": "https://www.youtube.com/watch?v=9SX9K1csx28"
    },
    {
      "title": "الدرس الثاني والعشرون- فتح مكة",
      "url": "https://www.youtube.com/watch?v=TSkXmxSs-pA"
    },
    {
      "title": "الدرس الثالث والعشرون- غزوة حنين وحصار الطائف",
      "url": "https://www.youtube.com/watch?v=ySswp1_bn4A"
    },
    {
      "title": "الدرس الرابع والعشرون- غزوة تبوك",
      "url": "https://www.youtube.com/watch?v=ZrcxE10HVoQ"
    },
    {
      "title": "الدرس الخامس والعشرون والأخير- وفاة النبي",
      "url": "https://www.youtube.com/watch?v=k8CLspkQSEk"
    },
  ];

  final ValueNotifier<int?> _currentlyPlayingIndex = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _currentlyPlayingIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary1,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          toolbarHeight: 100.h,
          centerTitle: true,
          backgroundColor: AppColors.primary1,
          shadowColor: AppColors.primary1,
          foregroundColor: AppColors.primary1,
          title: Text('السيره النبوية', style: AppTextStyles.headingsH1),
          leading: const SizedBox(width: 0.0),
          actions: [
            Row(
              children: [const CustomBackButton()],
            ),
          ],
        ));
  }
}
