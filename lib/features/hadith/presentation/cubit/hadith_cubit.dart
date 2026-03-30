import 'dart:convert';
import 'package:eghtanem_app/features/hadith/data/models/hadith_model.dart';
import 'package:eghtanem_app/features/hadith/presentation/cubit/hadith_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithCubit extends Cubit<HadithState> {
  HadithCubit() : super(HadithInitial()) {
    _init();
  }

  static const int _pageSize = 50;
  late SharedPreferences _prefs;
  final Set<int> _likedHadiths = {};
  List<Hadith> _allHadiths = [];
  int _loadedCount = 0;

  List<Hadith> get allHadiths => _allHadiths;

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadLikedHadiths();
    await _loadAllFromAsset();
    _emitNextPage();
  }

  Future<void> _loadAllFromAsset() async {
    emit(HadithLoading());
    try {
      final response =
          await rootBundle.loadString('assets/quran_metadata/ibn_maja.json');
      final data = json.decode(response) as List;
      _allHadiths = data.map((json) => Hadith.fromJson(json)).toList();
    } catch (e) {
      emit(HadithError(e.toString()));
    }
  }

  void _emitNextPage() {
    final end = (_loadedCount + _pageSize).clamp(0, _allHadiths.length);
    _loadedCount = end;
    emit(HadithLoaded(
      _allHadiths.sublist(0, _loadedCount),
      {..._likedHadiths},
      hasMore: _loadedCount < _allHadiths.length,
    ));
  }

  void loadMore() {
    if (state is! HadithLoaded) return;
    if (_loadedCount >= _allHadiths.length) return;
    _emitNextPage();
  }

  Future<void> loadHadiths() async {
    _loadedCount = 0;
    await _loadAllFromAsset();
    _emitNextPage();
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
    _prefs.setStringList(
        'likedHadiths', _likedHadiths.map((e) => e.toString()).toList());

    if (state is HadithLoaded) {
      final current = state as HadithLoaded;
      emit(HadithLoaded(current.hadiths, {..._likedHadiths},
          hasMore: current.hasMore));
    }
  }
}
