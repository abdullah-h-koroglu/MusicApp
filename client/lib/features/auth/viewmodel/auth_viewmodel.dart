import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/models/user_model.dart';
import 'package:client/features/auth/repositories/auth_locale_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocaleRepository _authLocaleRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocaleRepository = ref.watch(authLocaleRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocaleRepository.init();
  }

  Future<void> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: username,
      email: email,
      password: password,
    );

    if (!ref.mounted) return;

    final _ = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    if (!ref.mounted) return;

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        await _loginSuccess(r);
    }
  }

  Future<void> _loginSuccess(UserModel userModel) async {
    await _authLocaleRepository.setToken(userModel.token);
    _currentUserNotifier.addUser(userModel);
    state = AsyncValue.data(userModel);
  }

  Future<AsyncValue<UserModel>?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocaleRepository.getToken();

    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token: token);

      if (!ref.mounted) return null;

      return switch (res) {
        Left(value: final l) => () {
            state = AsyncValue.error(l.message, StackTrace.current);
            return null;
          }(),
        Right(value: final r) => _getDataSuccess(r)
      };
    }

    state = null;
    return null;
  }

  AsyncValue<UserModel>? _getDataSuccess(UserModel user){
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
