import 'dart:developer';
import 'dart:io';

import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_button_auth.dart';
import 'package:clean_login/presentation/screens/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../widget/back_buttom.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController _ctlPublicar = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _postProvider = Provider.of<PostProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              color: claro,
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
                  Container(
                    child: Column(
                      children: [
                        Container(
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
                        SizedBox(height: 12,),
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
                            : Container()
                      ],
                    ),
                  ),
                  
                ],
              )),
        ),
      ),
      bottomNavigationBar: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomBtn(
                      loading: _postProvider.createPostLoading,
                      textBtn: 'Publicar',
                      onTap: () async {
                        Provider.of<PostProvider>(context, listen: false)
                            .createPosts(_ctlPublicar.text, _image);
        
                            if(_image != null){
                           await Future.delayed(Duration(seconds: 3), () =>  Navigator.of(context).pop());
                            }else{
                               await Future.delayed(Duration(seconds: 1), () =>  Navigator.of(context).pop());
                            }
                        
                            showSnackBar(context, "Publicación", "Creada correctamente");
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
