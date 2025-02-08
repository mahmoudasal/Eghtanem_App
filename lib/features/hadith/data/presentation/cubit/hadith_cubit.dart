// hadith_cubit.dart
import 'dart:convert';
import 'package:egtanem_application/features/hadith/data/models/hadith_model.dart';
import 'package:egtanem_application/features/hadith/data/presentation/cubit/hadith_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HadithCubit extends Cubit<HadithState> {
  HadithCubit() : super(HadithInitial()) {
    _init();
  }

  late SharedPreferences _prefs;
  final Set<int> _likedHadiths = {};

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadLikedHadiths();
  }

  Future<void> loadHadiths() async {
    emit(HadithLoading());
    try {
      final hadiths = await _loadHadiths();
      emit(HadithLoaded(hadiths, _likedHadiths));
    } catch (e) {
      emit(HadithError(e.toString()));
    }
  }

  Future<List<Hadith>> _loadHadiths() async {
    final response = await rootBundle.loadString('assets/quran_metadata/ibn_maja.json');
    final data = json.decode(response) as List;
    return data.map((json) => Hadith.fromJson(json)).toList();
  }

  Future<void> _loadLikedHadiths() async {
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
    _prefs.setStringList('likedHadiths', _likedHadiths.map((e) => e.toString()).toList());
    if (state is HadithLoaded) {
      emit(HadithLoaded((state as HadithLoaded).hadiths, {..._likedHadiths}));
    }
  }
}