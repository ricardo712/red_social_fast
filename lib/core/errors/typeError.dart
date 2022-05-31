


String error(String e) {
  String noFoud           = "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.";
  String password         = "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.";
  String blockedAttempts  = "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.";
  String existAcount      = '[firebase_auth/email-already-in-use] The email address is already in use by another account.';
  
  if (noFoud == e || noFoud == "El usuario no existe") {
    return "Correo no valido";
  }else if(password == e){
    return 'La contraseña no es válida';
  }else if(blockedAttempts == e){
    return "Hemos bloqueado tu cuenta, Vuelve a intentarlo más tarde.";
  }else if(existAcount == e){
    return "La dirección de correo electrónico ya está siendo utilizada por otra cuenta.";
  }

  return e;
}
