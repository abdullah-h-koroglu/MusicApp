import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongPage extends ConsumerWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final recentlyPlayedSongs = ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Pallete.errorColor,
                Pallete.backgroundColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [
                0.0,0.1
              ]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16,bottom: 36),
                child: SizedBox(
                  height: 280,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 8
                    ),
                    itemCount: recentlyPlayedSongs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final currentSong = recentlyPlayedSongs[index];
                      return GestureDetector(
                        onTap: (){
                          ref.read(currentSongProvider.notifier).updateSong(currentSong);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Pallete.borderColor,
                            borderRadius: BorderRadius.circular(6)
                          ),
                          padding: EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Container(
                              width: 56,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(currentSong.thumbnail_url),fit: BoxFit.cover),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)
                                )
                              ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(child: Text(currentSong.song_name,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700),maxLines: 1,overflow: TextOverflow.ellipsis))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Latest today : ',
                  style: TextStyle(fontSize: 23,fontWeight: FontWeight.w700)
                  ),
              ),
          
              ref.watch(getAllSongsProvider)
              .when(
                data: (songs){
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final currentSong = songs[index];
                        return GestureDetector(
                          onTap: () {
                            ref
                            .read(currentSongProvider.notifier)
                            .updateSong(currentSong);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(image: NetworkImage(currentSong.thumbnail_url),fit: BoxFit.cover)
                                  ),
                                ),
                          
                                const SizedBox(height: 5),
                                
                                SizedBox(
                                  width: 180,
                                  child: Text(currentSong.song_name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                                ),
                          
                                 SizedBox(
                                  width: 180,
                                  child: Text(currentSong.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Pallete.subtitleText)),
                                )
                          
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }, 
                error: (error,st){
                  return Center(child: Text(error.toString()));
                }, 
                loading: () => const Loader()
                )
            ],
          ),
        ),
    );
  }
}