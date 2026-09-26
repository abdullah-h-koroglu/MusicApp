import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);
        final userFavorites = ref.watch(currentUserProvider.select((val) => val!.favorites));


    if (currentSong == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Pallete.errorColor,
            const Color(0xff121212),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Scaffold(
            backgroundColor: Pallete.transparentColor,
            appBar: AppBar(
              backgroundColor: Pallete.transparentColor,
              leading: Transform.translate(
                offset: const Offset(-15, 0),
                child: InkWell(
                  highlightColor: Pallete.transparentColor,
                  splashColor: Pallete.transparentColor,
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: Pallete.whiteColor,
                    ),
                  ),
                ),
              ),
            ),

            body: SingleChildScrollView(
              child: Column(
                children: [
                  // ALBUM COVER
                  AspectRatio(
                    aspectRatio: 1,
                    child: Hero(
                      tag: 'music-image',
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              currentSong.thumbnail_url,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // SONG INFO
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.song_name,
                              style: const TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              currentSong.artist,
                              style: const TextStyle(
                                color: Pallete.subtitleText,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () async{
                          await ref.read(homeViewModelProvider.notifier)
                          .favoriteSong(songId: currentSong.id);
                        },
                        icon: Icon(
                          // checks : 
                          userFavorites.where((fav) => fav.song_id == currentSong.id).toList().isNotEmpty
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart_fill,
                          size: 18
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const SizedBox();
                      }
                      final position = snapshot.data;
                      final duration =songNotifier.audioPlayer!.duration;
                      double sliderValue = 0.0;
                
                      if(position != null && duration != null){
                        sliderValue = position.inMilliseconds/duration.inMilliseconds;
                      }
                      
                      return Column(
                      children: [
                    // SLIDER   
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Pallete.whiteColor,
                        inactiveTrackColor:
                            Pallete.whiteColor.withOpacity(0.117),
                        thumbColor: Pallete.whiteColor,
                        trackHeight: 4,
                        overlayShape:
                            SliderComponentShape.noOverlay,
                      ),
                      child: Slider(
                        value: sliderValue,
                        min: 0,
                        max: 1,
                        onChanged: (value) {
                          sliderValue = value;
                        },
                        onChangeEnd: songNotifier.seek,
                      ),
                    ),
                    
                    // TIME
                     Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${position?.inMinutes}:${(position?.inSeconds ?? 0) < 10 ? '0${position?.inSeconds}' : position?.inSeconds}',
                            style: const TextStyle(
                              color: Pallete.subtitleText,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            '${duration?.inMinutes}:${(duration?.inSeconds ?? 0) < 10 ? '0${duration?.inSeconds}' : duration?.inSeconds}',
                            style: TextStyle(
                              color: Pallete.subtitleText,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                      ],
                    );
                    }
                  ),

                  const SizedBox(height: 15),

        
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.shuffle,
                        size: 18,
                        color: Pallete.whiteColor,
                      ),

                      Icon(
                        Icons.skip_previous,
                        size: 22,
                        color: Pallete.whiteColor,
                      ),

                      IconButton(
                        onPressed: songNotifier.playPause,
                        icon : Icon(Icons.play_arrow,
                        size: 32,
                        color: Pallete.whiteColor,),
                      ),

                      Icon(
                        Icons.skip_next,
                        size: 22,
                        color: Pallete.whiteColor,
                      ),

                      Icon(
                        Icons.replay,
                        size: 22,
                        color: Pallete.whiteColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // BOTTOM CONTROLS
                  Row(
                    children: [
                      Icon(
                        Icons.connect_without_contact,
                        size: 18,
                        color: Pallete.whiteColor,
                      ),

                      const Spacer(),

                      Icon(
                        Icons.connect_without_contact,
                        size: 18,
                        color: Pallete.whiteColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}