// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_locale_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authLocaleRepository)
final authLocaleRepositoryProvider = AuthLocaleRepositoryProvider._();

final class AuthLocaleRepositoryProvider
    extends
        $FunctionalProvider<
          AuthLocaleRepository,
          AuthLocaleRepository,
          AuthLocaleRepository
        >
    with $Provider<AuthLocaleRepository> {
  AuthLocaleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLocaleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLocaleRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthLocaleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthLocaleRepository create(Ref ref) {
    return authLocaleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthLocaleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthLocaleRepository>(value),
    );
  }
}

String _$authLocaleRepositoryHash() =>
    r'76fd113f6b985a9e5ea6e615ec452acdba4aa9ae';
