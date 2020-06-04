class EmptyValidator {
  final String message;

  EmptyValidator({this.message});

  String validate(String value) {
    if (value.isEmpty) {
      return message == null ? 'This field is required.' : message;
    }
    return null;
  }
}
