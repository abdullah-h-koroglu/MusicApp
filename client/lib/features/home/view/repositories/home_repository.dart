import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/theme/failiure/failure.dart';
import 'package:client/features/home/view/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homerepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<Failure,String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artistName,
    required String hexCode,
    required String token
    }) 
  async{
  try{
      final request = http.MultipartRequest(
      'POST', 
      Uri.parse('${ServerConstants.serverUrl}/song/upload')
      );

      request..files.addAll([
        await http.MultipartFile.fromPath('song',selectedAudio.path),
        await http.MultipartFile.fromPath('thumbnail',selectedThumbnail.path)
      ],)..fields.addAll({
        'artist' : artistName,
        'song_name' : songName,
        'hex_code' :hexCode
      })..headers.addAll({
        'x-auth-token' : token
      },);


      final res = await request.send();

      if(res.statusCode != 201){
        return Left(Failure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure,List<SongModel>>> getAllSongs({
    required String token
  }
  ) async { 
    try{
      final res = await http.get(
        Uri.parse('${ServerConstants.serverUrl}/song/list'),
        headers: {
          'Content-Type':'application/json',
          'x-auth-token':token
        });

        var resBodyMap = jsonDecode(res.body);

        if(res.statusCode != 200){
          resBodyMap = resBodyMap as Map<String,dynamic>;
          return Left(Failure(resBodyMap['detail']));
        }

        resBodyMap = resBodyMap as List;
        List<SongModel> songs = [];

        for(final map in resBodyMap){
          songs.add(SongModel.fromMap(map));
        }
        
        return Right(songs);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure,bool>> favSong({
    required String token,
    required String songId
  }
  ) async { 
    try{
      final res = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/song/favorite'),
        headers: {
          'Content-Type':'application/json',
          'x-auth-token':token
        },
        body: jsonEncode(
        {
          "song_id":songId
        }
        )
        );

        var resBodyMap = jsonDecode(res.body);

        if(res.statusCode != 200){
          resBodyMap = resBodyMap as Map<String,dynamic>;
          return Left(Failure(resBodyMap['detail']));
        }
        return Right(resBodyMap['message']);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure,List<SongModel>>> getAllFavSongs({
    required String token
  }
  ) async { 
    try{
      final res = await http.get(
        Uri.parse('${ServerConstants.serverUrl}/song/list/favorites'),
        headers: {
          'Content-Type':'application/json',
          'x-auth-token':token
        });

        var resBodyMap = jsonDecode(res.body);

        if(res.statusCode != 200){
          resBodyMap = resBodyMap as Map<String,dynamic>;
          return Left(Failure(resBodyMap['detail']));
        }

        resBodyMap = resBodyMap as List;
        List<SongModel> songs = [];

        for(final map in resBodyMap){
          songs.add(SongModel.fromMap(map['song']));
        }
        
        return Right(songs);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }
}