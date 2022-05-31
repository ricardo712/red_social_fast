


import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:clean_login/presentation/blocs/providers/friendProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_login/presentation/blocs/myuser_controller.dart';

class BtnState extends StatefulWidget {
  const BtnState({ Key? key, required this.friendId }) : super(key: key);
  final String friendId;


  @override
  State<BtnState> createState() => _BtnStateState();
}

class _BtnStateState extends State<BtnState> {
  @override
  Widget build(BuildContext context) {
     final state = Provider.of<FriendProvider>(context);
    return InkWell(
      onTap: () async {
        if(state.stateSolicitude == ""){
          Provider.of<FriendProvider>(context, listen: false).createStateSolicitude(getIt<MyUserData>().idUser, widget.friendId);
        }
        if(state.stateSolicitude == "pendiente1"){
          Provider.of<FriendProvider>(context, listen: false).aceptarStateSolicitude([getIt<MyUserData>().idUser, widget.friendId]);
        }
         if(state.stateSolicitude == "aceptado"){
          _showMyDialog(context, [getIt<MyUserData>().idUser, widget.friendId]);
        }
         if(state.stateSolicitude == "pendiente"){
          _showMyDialogdelete(context, [getIt<MyUserData>().idUser, widget.friendId]);
        }
      },
      child: AnimatedContainer(
        
                width: state.stateSolicitude == "loading" ? 60 : 170,
                height: 50,
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.stateSolicitude == "loading")
                      const Center(
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 255, 255, 255),
                                strokeWidth: 2.0,
                              )))
                    else
                      ContentButtom(
                        loading: state.stateSolicitude,
                      ),
                  ],
                ),
              ),
    );
  }
  Future<void> _showMyDialog(BuildContext context, List<String> users) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Desea eliminar la solicitud'),
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
                'Eliminar solicitud',
                style: TextStyle(color: primary),
              ),
              onPressed: () {
                Provider.of<FriendProvider>(context, listen: false).eliminarFriends(users);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
Future<void> _showMyDialogdelete(BuildContext context, List<String> users) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Desea cancelar la solicitud'),
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
                'Cancelar solicitud',
                style: TextStyle(color: primary),
              ),
              onPressed: () {
                Provider.of<FriendProvider>(context, listen: false).cancelarFriends(users);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



class ContentButtom extends StatelessWidget {
  const ContentButtom({
    Key? key,
    required this.loading,
  }) : super(key: key);

  final String loading;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(value(loading),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  String value(String loading){
    if(loading == "pendiente"){
      return "Solicitud enviada";
    }else if(loading == "pendiente1"){
      return "Aceptar solicitud";
    }else if(loading == "aceptado"){
      return "Amigos";
    }else if(loading == ""){
      return "Enviar solicitud";
    }else{
       return "Enviar solicitud";
    }
  }

  
}