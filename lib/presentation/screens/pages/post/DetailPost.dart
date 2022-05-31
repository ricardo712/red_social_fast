import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:clean_login/presentation/blocs/providers/commetsProvider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_login/presentation/blocs/myuser_controller.dart';

class DetailPost extends StatefulWidget {
  const DetailPost({Key? key, required this.data}) : super(key: key);
  final PostData data;

  @override
  State<DetailPost> createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  TextEditingController _ctlcommentar = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final dataComments = Provider.of<CommentsProvider>(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: primary),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            widget.data.attachments != ""
                ? SliverToBoxAdapter(
                    child: Container(
                        width: double.infinity,
                        height: 250,
                        child: CachedNetworkImage(
                          imageUrl: widget.data.attachments,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                color: primary,
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                  )
                : Container(),
            SliverToBoxAdapter(
              child: Container(
                  height: widget.data.content.length > 150 ? 140 : 100,
                  width: double.infinity,
                  child: Card(
                      color: claro,
                      elevation: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: claro,
                                      child: ClipOval(
                                          child: CachedNetworkImage(
                                        imageUrl:
                                            widget.data.publicUser!.photoUrl!,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              color: primary,
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ))),
                                ),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                        widget.data.publicUser!.userName!,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                              child: ExpandableText(widget.data.content,
                                  expandText: 'Ver más',
                                  collapseText: 'Ver menos',
                                  maxLines: 4,
                                  linkColor: primary,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 12)),
                            )),
                          ]))),
            ),
            SliverToBoxAdapter(
              child: dataComments.item != null && !dataComments.loading
                  ? Container(
                    height: 400,
                      child: dataComments.item!.length > 0
                          ? ListView.builder(
                              itemCount: dataComments.item!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(8),
                                  height: 100,
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: CircleAvatar(
                                                radius: 15,
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: dataComments
                                                        .item![index]
                                                        .publicUser!
                                                        .photoUrl,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Center(
                                                      child: CircularProgressIndicator(
                                                          color: primary,
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                    ),
                                                    errorWidget: (context,
                                                            url, error) =>
                                                        Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  dataComments.item![index]
                                                      .publicUser!.userName,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                            child: SingleChildScrollView(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: ExpandableText(
                                                dataComments
                                                    .item![index].content,
                                                expandText: 'Ver más',
                                                collapseText: 'Ver menos',
                                                maxLines: 4,
                                                linkColor: primary,
                                                textAlign: TextAlign.justify,
                                                style:
                                                    TextStyle(fontSize: 12)),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text("No hay comentarios"),
                            ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _showMyDialog(context);
          },
          backgroundColor: primary,
          child: Icon(
            Icons.add_comment,
            color: claro,
          )),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir comentario'),
          content: TextFormField(
            controller: _ctlcommentar,
            cursorColor: primary,
            decoration: new InputDecoration(
                errorStyle: TextStyle(fontSize: 12.0, color: secondary),
                filled: true,
                fillColor: Colors.white,
                hintText: "¿ qué estas pensando?",
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
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: secondary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Publicar',
                style: TextStyle(color: primary),
              ),
              onPressed: () {
                Provider.of<CommentsProvider>(context, listen: false)
                    .createPosts(_ctlcommentar.text, getIt<MyUserData>().idUser,
                        widget.data.uid, widget.data);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
