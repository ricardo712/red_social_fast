String? validateEmail(String? value) {
  String pattern = "[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+";
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value!))
    return 'Ingresa correo eletrónico valido*';

}

String? validatePassword(String? password) {
  if (password!.length < 6 ) {
    return 'Ingresa La contraseña valida, minimo 6 caracteres';
  } 
}


String? validatePhone(String? identification) {
  if (identification!.length < 10) {
    return 'Ingresa un numero valido*';
  }
}

  String? validatename(String? name) {
  if (name!.length < 3) {
    return 'Ingresa un usuario valido*';
  } 
}


