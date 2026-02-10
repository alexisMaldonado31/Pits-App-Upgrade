RegExp expresionCorreos = new RegExp(
    r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");
RegExp expresionPass = new RegExp(r"^[0-9a-zA-Z]{4,10}$");
RegExp expressionSoloLetras = new RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+");
RegExp expressionLetrasNumeros = new RegExp(r"^[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+");
RegExp expressionSoloNumeros = new RegExp(r"^([0-9]+(?:[0-9]*)?|[0-9]+)$");

bool comprobarCorreo(String email) {
  return expresionCorreos.hasMatch(email);
}

bool comprobarContrasenia(String pass) {
  return expresionPass.hasMatch(pass);
}

bool comprobarSoloLetras(String value) {
  return expressionSoloLetras.hasMatch(value);
}

bool comprobarSoloNumeros(String value) {
  for (int i = 0; i < value.length; i++) {
    if (!expressionSoloNumeros.hasMatch(value[i])) return false;
  }
  return true;
}

bool comprobarLetrasNumeros(String value) {
  return expressionLetrasNumeros.hasMatch(value);
}

bool comprobarCampoNoVacio(String value) {
  return value.length != 0 ? true : false;
}

bool comprobarCedula(String cedula) {
  if (cedula.length == 0) return false;
  List<int> multiplicadores = [2, 1, 2, 1, 2, 1, 2, 1, 2];
  int valor = 0;
  try {
    for (int i = 0; i < cedula.length - 1; i++) {
      valor += multiplicadores[i] * int.parse(cedula[i]) >= 10
          ? (multiplicadores[i] * int.parse(cedula[i])) - 9
          : (multiplicadores[i] * int.parse(cedula[i]));
    }
  } catch (e) {
    return false;
  }

  return 10 - (valor % 10) == int.parse(cedula[9]) ? true : false;
}

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}
