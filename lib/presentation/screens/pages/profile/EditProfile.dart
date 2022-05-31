import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:clean_login/presentation/blocs/providers/friendProvider.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_button_auth.dart';
import 'package:clean_login/presentation/screens/pages/Home.dart';
import 'package:clean_login/presentation/screens/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.user}) : super(key: key);
  final UserEntities user;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nombre = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    nombre.text = widget.user.usuario;
    final provider = Provider.of<FriendProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: _image != null
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
                    : CircleAvatar(
                        radius: 80,
                        backgroundColor: claro,
                        child: ClipOval(
                            child: CachedNetworkImage(
                              width: double.infinity,
                              fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                color: primary,
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ))),
              ),
              SizedBox(
                height: 12,
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
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  controller: nombre,
                  cursorColor: primary,
                  decoration: new InputDecoration(
                      errorStyle: TextStyle(fontSize: 12.0, color: secondary),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Nombre de usuario",
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(color: primary),
                      ),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: primary,
                            width: 0.5,
                            // style: BorderStyle.none
                          )),
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.black,
                              style: BorderStyle.none,
                              width: 0.0))),
                ),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomBtn(
          loading: provider.loadingUpdateuser,
          textBtn: 'Editar',
          onTap: () async {
            final datauser = UserEntities(
                usuario: nombre.text,
                email: widget.user.email,
                password: "",
                id: widget.user.id,
                status: widget.user.status,
                image: widget.user.image);
            Provider.of<FriendProvider>(context, listen: false)
                .updateUser(datauser, _image, context);

            if (_image != null) {
              await Future.delayed(
                  Duration(seconds: 7), () => Navigator.push(context, MaterialPageRoute(builder: (_) => Home())));
                  showSnackBar(context, "Perfil", "Actualizado correctamente");
            } else {
              await Future.delayed(
                  Duration(seconds: 1), () => Navigator.of(context).pop());
                  showSnackBar(context, "Perfil", "Actualizado correctamente");
            }

            
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
