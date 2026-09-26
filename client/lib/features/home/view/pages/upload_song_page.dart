import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/viewmodel/home_viewmodel.dart';
import 'package:client/features/home/view/widget/audio_wave.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _MyWidgetState();
}



class _MyWidgetState extends ConsumerState<UploadSongPage> {

final songNameController = TextEditingController();
final artistController = TextEditingController();
Color selectedColor = Pallete.cardColor;
File? selectedImage;
File? selectedAudio;
final formkey = GlobalKey<FormState>();

void selectImage() async {
  final pickedImage = await pickImage();
  if(pickedImage != null){
    setState(() {
      selectedImage = pickedImage;
    });
  }
}

void selectAudio() async {
  final pickedAudio = await pickAudio();
  if(pickedAudio != null){
    setState(() {
      selectedAudio = pickedAudio;
    });
  }
}

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(homeViewModelProvider.select((val) => val?.isLoading == true));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        actions: [
          IconButton(onPressed: () async {
            if(formkey.currentState!.validate() && selectedAudio!= null && selectedImage != null){
            ref.read(homeViewModelProvider.notifier).
            uploadSong(
              selectedAudio: selectedAudio!,
              selectedThumbnail: selectedImage!,
              songName: songNameController.text,
              artistName: artistController.text,
              selectedColor: selectedColor);
            }else{
              showSnackBar(context, "Missing Fields");
            }
          }, icon: const Icon(Icons.check))
        ],
      ),
      body: isLoading
      ? Loader()
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child: 
                  selectedImage!= null ? Image.file(selectedImage!) : DottedBorder(
                    child: SizedBox(
                    height: 159,
                    width: double.infinity,
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder_open,size: 40),
                          const SizedBox(height: 15),
                          Text('Select the thumbnail',style: TextStyle(fontSize: 15))
                        ],
                    ),
                  )
                  ),
                ),
                const SizedBox(height: 40),
            
                selectedAudio != null 
                ? AudioWave(path: selectedAudio!.path) 
                : CustomField(hintText: 'Pick A  Song', controller: null,onTap: selectAudio),
            
                const SizedBox(height: 20),
                CustomField(hintText: 'Artist', controller: artistController),
                const SizedBox(height: 20),
                CustomField(hintText: 'Song Name', controller: songNameController),
                const SizedBox(height: 20),
                ColorPicker(
                  pickersEnabled: const {
                    ColorPickerType.wheel: true
                  },
                  color: selectedColor,
                  onColorChanged: (Color color){
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}