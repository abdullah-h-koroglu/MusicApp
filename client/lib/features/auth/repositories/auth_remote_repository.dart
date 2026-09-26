import 'dart:convert';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/theme/failiure/failure.dart';
import 'package:client/core/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<Failure,UserModel>> signup({
    required String name,
    required String email, 
    required String password}
    ) async {
      try{
      final response = await http.post(
            headers: {
              'Content-Type': 'application/json',
            },
            Uri.parse('${ServerConstants.serverUrl}/auth/signup'),
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password
              })
          );
          final respBodyMap = jsonDecode(response.body) as Map<String,dynamic>;

          if(response.statusCode != 201){
            return Left(Failure(respBodyMap['detail']));
          }
          return Right(UserModel.fromMap(respBodyMap));
      }catch(e){
         return Left(Failure(e.toString()));
      }
  }

  Future<Either<Failure,UserModel>> login({
    required String email,
    required String password,
  }) async{

    try{ 
      final response = await http.post(
      headers: {
        'Content-Type': 'application/json',
      },
      Uri.parse('${ServerConstants.serverUrl}/auth/login'),
      body: jsonEncode({
        'email': email,
        'password': password
        })
    );

    final respBodyMap = jsonDecode(response.body) as Map<String,dynamic>;

    if(response.statusCode != 200){
      return Left(Failure(respBodyMap['detail']));
    }

    final userMap = respBodyMap['user'] is Map<String, dynamic>
        ? respBodyMap['user'] as Map<String, dynamic>
        : respBodyMap;
    final token = (respBodyMap['token'] ??
            respBodyMap['access_token'] ??
            userMap['token'] ??
            '')
        .toString();

    return Right(UserModel.fromMap(userMap).copyWith(token: token));
    }
    catch(e){
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure,UserModel>> getCurrentUserData({
    required String token,
  }) async{

    try{ 
      final response = await http.get(
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      Uri.parse('${ServerConstants.serverUrl}/auth/'),
    );

    final respBodyMap = jsonDecode(response.body) as Map<String,dynamic>;

    if(response.statusCode != 200){
      return Left(Failure(respBodyMap['detail']));
    }

    final userMap = respBodyMap['user'] is Map<String, dynamic>
        ? respBodyMap['user'] as Map<String, dynamic>
        : respBodyMap;

    return Right(UserModel.fromMap(userMap).copyWith(token: token));
    }
    catch(e){
      return Left(Failure(e.toString()));
    }
  }
}