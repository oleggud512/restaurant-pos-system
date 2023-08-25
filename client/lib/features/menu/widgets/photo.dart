import 'dart:io';

import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/services/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../services/repo.dart';

class Photo extends StatefulWidget {
  const Photo({Key? key, required this.dish, this.edit=true, this.height=200}) : super(key: key);

  final Dish dish;
  final bool edit;
  final double height;

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  /*
    тут должно быть 
    сначала: отображение картинки по dish.photoIndex (получаем из специального метода в repo)
      тогда отображается ИЛИ дефолтная картинка ИЛИ та что "типа" есть
      там же есть кнопка изменить (которая появляется только если edit)
  */
  late String url;
  late Widget _photo; // загружено из инета

  @override
  void initState() {
    super.initState();
    url = Provider.of<Repo>(context, listen: false).getImagePath(imageId: widget.dish.dishPhotoIndex);
    _updateImgWidget();
  }

  _updateImgWidget() async {
    setState(() {
      _photo = const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    });
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
    setState(() {
      _photo = Image.memory(bytes, height: 200);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.edit ? Column(
      children: [
        // (widget.dish.photo == null) ? Image.network(
        //     Provider.of<Repo>(context, listen: false).getImagePath(imageId: widget.dish.dishPhotoIndex),
        //     height: 200,
        //   ) : Image.file(widget.dish.photo!, height: 200),
        (widget.dish.photo == null) ? _photo : Image.file(widget.dish.photo!, height: widget.height),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text(AppLocalizations.of(context)!.choose_image, overflow: TextOverflow.ellipsis,),
                onPressed: () async {
                  setPhoto();
                },
              ),
            ),
            const SizedBox(width: 10,),
            ElevatedButton(
              child: const Icon(Icons.close),
              onPressed: () async {
                widget.dish.dishPhotoIndex = 0;
                url = Provider.of<Repo>(context, listen: false).getImagePath(imageId: 0);
                _updateImgWidget();
              },
            ),
          ],
        )
      ]
    ) : _photo;
  }

  Future<void> setPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) { return; }
    widget.dish.dishPhotoIndex = widget.dish.dishId ?? 0;
    File file = File(result.files.single.path!);
    setState(() {
      widget.dish.photo = file;
    });
  }
}