import 'package:client/features/home/view/models/song_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_locale_repository.g.dart';

@riverpod
HomeLocaleRepository homeLocaleRepository(Ref ref) {
  return HomeLocaleRepository();
}

class HomeLocaleRepository {
  final Box box = Hive.box('myBox');

  void uploadLocaleSong(SongModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongModel> loadSong() {
    List<SongModel> songs = [];

    for (final key in box.keys) {
      songs.add(
        SongModel.fromJson(
          box.get(key),
        ),
      );
    }

    return songs;
  }
}