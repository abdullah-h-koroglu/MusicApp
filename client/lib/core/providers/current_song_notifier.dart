import 'package:client/features/home/view/repositories/home_locale_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/home/view/models/song_model.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {

  late HomeLocaleRepository _localeRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  SongModel? build() {
    _localeRepository = ref.watch(homeLocaleRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async{
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer(); 

    final audioSource = AudioSource.uri(Uri.parse(song.song_url)
    ,tag:MediaItem(
      id: song.id,
       title: song.song_name,
       artist: song.artist,
       artUri: Uri.parse(song.thumbnail_url)
    ),
  );
    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((statel) {
      if(statel.processingState == ProcessingState.completed){
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        state = state?.copyWith(hex_code: this.state?.hex_code);
      }
    });
    
    _localeRepository.uploadLocaleSong(song);
    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause(){
    if(isPlaying){
      audioPlayer?.pause();
    }else{
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double val){
    audioPlayer!.seek(Duration(milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt()));
  }
}