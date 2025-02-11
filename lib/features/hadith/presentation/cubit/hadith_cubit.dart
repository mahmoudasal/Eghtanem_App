import 'dart:convert';
import 'package:egtanem_application/features/hadith/data/models/hadith_model.dart';
import 'package:egtanem_application/features/hadith/presentation/cubit/hadith_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithCubit extends Cubit<HadithState> {
  HadithCubit() : super(HadithInitial()) {
    _init();
  }

  late SharedPreferences _prefs;
  final Set<int> _likedHadiths = {};

   /// ✅ Initialize SharedPreferences and Load Liked Hadiths
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadLikedHadiths(); // ✅ Load liked hadiths first
    await loadHadiths(); // ✅ Then load all hadiths
  }

  Future<void> loadHadiths() async {
    emit(HadithLoading());
    try {
      final hadiths = await loadAllHadiths();
      emit(HadithLoaded(hadiths, {..._likedHadiths})); // ✅ Include liked hadiths
    } catch (e) {
      emit(HadithError(e.toString()));
    }
  }

 Future<List<Hadith>> loadAllHadiths() async {
    final response = await rootBundle.loadString('assets/quran_metadata/ibn_maja.json');
    final data = json.decode(response) as List;
    return data.map((json) => Hadith.fromJson(json)).toList();
  }

   Future<void> loadLikedHadiths() async {
    final likedHadithStrings = _prefs.getStringList('likedHadiths');
    if (likedHadithStrings != null) {
      _likedHadiths.addAll(likedHadithStrings.map(int.parse));
    }
  }

    void toggleLike(int hadithNumber) {
    if (_likedHadiths.contains(hadithNumber)) {
      _likedHadiths.remove(hadithNumber);
    } else {
      _likedHadiths.add(hadithNumber);
    }

    // ✅ Save to SharedPreferences
    _prefs.setStringList('likedHadiths', _likedHadiths.map((e) => e.toString()).toList());

    if (state is HadithLoaded) {
      emit(HadithLoaded((state as HadithLoaded).hadiths, {..._likedHadiths}));
    }
  }
}