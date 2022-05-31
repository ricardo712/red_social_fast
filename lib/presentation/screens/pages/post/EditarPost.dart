import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_button_auth.dart';
import 'package:clean_login/presentation/screens/widget/back_buttom.dart';
import 'package:clean_login/presentation/screens/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class EditarPost extends StatefulWidget {
  const EditarPost({Key? key, required this.data}) : super(key: key);
  final PostData data;

  @override
  State<EditarPost> createState() => _EditarPostState();
}

class _EditarPostState extends State<EditarPost> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController _ctlPublicar = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ctlPublicar.text = widget.data.content;
    final _postProvider = Provider.of<PostProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: claro,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    BackButtomContainer(),
                    Spacer(),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Crear Publicación",
                          style: TextStyle(
                            color: primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: claro,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: TextFormField(
                              controller: _ctlPublicar,
                              cursorColor: primary,
                              decoration: new InputDecoration(
                                  errorStyle: TextStyle(
                                      fontSize: 12.0, color: secondary),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "¿ qué estas pensando?",
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(color: primary),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(
                                        color: primary,
                                        width: 0.5,
                                        // style: BorderStyle.none
                                      )),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                          color: Colors.black,
                                          style: BorderStyle.none,
                                          width: 0.0))),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => _openCamera(context),
                                icon: Icon(
                                  Ionicons.camera,
                                  color: primary,
                                )),
                            IconButton(
                                onPressed: () => _openGallery(context),
                                icon: Icon(
                                  Ionicons.image,
                                  color: primary,
                                )),
                          ],
                        ),
                        _image != null
                            ? Container(
                                width: double.infinity,
                                height: 200,
                                color: primary,
                                margin: EdgeInsets.all(5),
                                child: Stack(
                                  children: [
                                    Center(
                                        child: Image(
                                      image: FileImage(_image!),
                                      fit: BoxFit.contain,
                                    )),
                                    IconButton(
                                        color: claro,
                                        onPressed: () {
                                          setState(() {
                                            _image = null;
                                          });
                                        },
                                        icon: Icon(
                                          Ionicons.close,
                                          size: 30,
                                        ))
                                  ],
                                ),
                              )
                            : widget.data.attachments != ""
                                ? Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: primary,
                                    margin: EdgeInsets.all(5),
                                    child: Stack(
                                      children: [
                                        Center(
                                            child: CachedNetworkImage(
                                          imageUrl: widget.data.attachments,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                                color: primary,
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )),
                                      ],
                                    ),
                                  )
                                : Container()
                      ],
                    ),
                  ),
                ),
                
              ],
            )),
          
      ),
      bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomBtn(
                    loading: _postProvider.createPostLoading,
                    textBtn: 'Editar',
                    onTap: () async {
                      Provider.of<PostProvider>(context, listen: false)
                          .editPosts(widget.data, _image, _ctlPublicar.text);

                      if (_image != null) {
                        await Future.delayed(Duration(seconds: 3),
                            () => Navigator.of(context).pop());
                      } else {
                        await Future.delayed(Duration(seconds: 1),
                            () => Navigator.of(context).pop());
                      }

                      showSnackBar(
                          context, "Publicación", "Editada correctamente");
                    },
                  ),
                ),
    );
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    try {
      setState(() {
        _image = File(pickedFile!.path);
      });
    } catch (e) {}
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    try {
      setState(() {
        _image = File(pickedFile!.path);
      });
    } catch (e) {}
  }
}
