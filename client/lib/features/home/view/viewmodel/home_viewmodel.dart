import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/models/fav_song_model.dart';
import 'package:client/features/home/view/models/song_model.dart';
import 'package:client/features/home/view/repositories/home_locale_repository.dart';
import 'package:client/features/home/view/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider.select((user)=> user!.token));
  final res = await 
  ref.watch(homerepositoryProvider).getAllSongs(token: token);

  return switch(res){
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider.select((user) => user!.token));
  final res = await 
  ref.watch(homerepositoryProvider).getAllFavSongs(token: token);

  return switch(res){
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}



@riverpod
class HomeViewModel extends _$HomeViewModel{
  late HomeRepository _homeRepository;
  late HomeLocaleRepository _homeLocaleRepository;

  @override
  AsyncValue? build(){
    _homeRepository = ref.watch(homerepositoryProvider);
    _homeLocaleRepository = ref.watch(homeLocaleRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artistName,
    required Color selectedColor
  })async {

    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName, 
      artistName: artistName,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserProvider)!.token,
      );

    final val = switch(res) {
     Left(value: final l ) => state = .error(l.message, StackTrace.current),
     Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  List<SongModel> getRecentlyPlayedSongs(){
    return _homeLocaleRepository.loadSong();
  }

Future<void> favoriteSong({
    required String songId
  })async {

    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
      token: ref.read(currentUserProvider)!.token, 
      songId: songId
      );

    final val = switch(res) {
     Left(value: final l ) => state = .error(l.message, StackTrace.current),
     Right(value: final r) => _favoriteSongSuccess(r, songId)
    };
    print(val);
  }

  AsyncValue _favoriteSongSuccess(bool isFavorited,String songId){
    final userNotifier = ref.read(currentUserProvider.notifier);
    if(isFavorited){
      userNotifier.addUser(
        ref.read(currentUserProvider)!.copyWith(
          favorites: [
            ...ref.read(currentUserProvider)!.favorites,
            FavSongModel(
              id: 'id',
              song_id: songId, 
              user_id: ''
              )
          ]
        )
      );
    }else{
      userNotifier.addUser(
        ref.read(currentUserProvider)!.copyWith(
          favorites: ref.read(currentUserProvider)!.favorites.where((fav) => fav.song_id != songId,).toList()
        )
      );
    }
    ref.invalidate(getFavSongsProvider);
    return AsyncValue.data(isFavorited);
  }

}