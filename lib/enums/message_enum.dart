enum MessageEnum {
  EMAIL_EXISTS('El correo diligenciado ya se encuentra registrado'),
  INVALID_LOGIN_CREDENTIALS('El correo y/o la contraseña son incorrectos');

  final String value;

  const MessageEnum(this.value);

  static MessageEnum searchByKey(String message) {
    return values.firstWhere((e) => e.toString() == 'MessageEnum.$message');
  }
}