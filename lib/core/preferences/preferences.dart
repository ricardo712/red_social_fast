import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class Preferences {
  SharedPreferences preferences;
  Preferences({required this.preferences});

  final String? authtoken = "auth_token";

//set data into shared preferences like this
  Future<bool> setAuthToken(String authtoken) async {
    return preferences.setString(this.authtoken!, authtoken);
  }

//get value from shared preferences
  Future<String> getAuthToken() async {
    String authtoken;
    authtoken = preferences.getString(this.authtoken!) ?? '';
    return authtoken;
  }

  removeUser() async {
    preferences.remove(authtoken!);
  }
}
