// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_locale_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeLocaleRepository)
final homeLocaleRepositoryProvider = HomeLocaleRepositoryProvider._();

final class HomeLocaleRepositoryProvider
    extends
        $FunctionalProvider<
          HomeLocaleRepository,
          HomeLocaleRepository,
          HomeLocaleRepository
        >
    with $Provider<HomeLocaleRepository> {
  HomeLocaleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeLocaleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeLocaleRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeLocaleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeLocaleRepository create(Ref ref) {
    return homeLocaleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeLocaleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeLocaleRepository>(value),
    );
  }
}

String _$homeLocaleRepositoryHash() =>
    r'0d5b0a20c4a73f7c1140f8f82746848fd8801dbe';
