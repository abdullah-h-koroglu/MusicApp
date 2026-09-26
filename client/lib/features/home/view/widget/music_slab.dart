import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/viewmodel/home_viewmodel.dart';
import 'package:client/features/home/view/widget/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);
    final userFavorites = ref.watch(currentUserProvider.select((val) => val!.favorites));

    print(songNotifier.isPlaying);
    if(currentSong==null){
      return const SizedBox();
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const MusicPlayer();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final tween =
                    Tween(begin: const Offset(0, 1), end: Offset.zero).chain(
                  CurveTween(
                    curve: Curves.easeIn,
                  ),
                );
      
                final offsetAnimation = animation.drive(tween);
      
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
        child: Stack(
          children:[ 
            Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              
            ),
            padding: const EdgeInsets.all(9),
            height: 66,
            width: MediaQuery.of(context).size.width - 5,
            child: Hero(
              tag: 'music-image',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: 48,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(currentSong.thumbnail_url),fit: BoxFit.cover)
                      ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Pallete.subtitleText),
                          )
                        ],
                      )
                  ],)
                  ,
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await ref.read(homeViewModelProvider.notifier)
                          .favoriteSong(songId: currentSong.id);
                        }, 
                        icon: Icon(
                          // checks : 
                          userFavorites.where((fav) => fav.song_id == currentSong.id).toList().isNotEmpty
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart_fill,
                          size: 18)
                      ),
                      IconButton(
                        onPressed: songNotifier.playPause, 
                        icon: Icon(
                          songNotifier.isPlaying 
                          ? Icons.play_arrow_rounded 
                          : Icons.stop_circle
                          ,size: 18
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
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
        
              return Positioned(
              left: 8,
              bottom: 0,
              child: Container(
                height: 2,
                width: sliderValue * (MediaQuery.of(context).size.width - 32),
                decoration: const BoxDecoration(
                  color: Pallete.whiteColor
                ),
              )
            );
            }
          ),
          Positioned(
              left: 8,
              bottom: 0,
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width-32,
                decoration: const BoxDecoration(
                  color: Pallete.inactiveSeekColor
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}