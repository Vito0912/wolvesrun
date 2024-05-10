import 'package:wolvesrun/models/Laravel.dart';

class ValidationError extends Laravel {
  final Map<String, List<String>> fieldErrors;

  ValidationError({required this.fieldErrors});

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> fieldErrors = {};
    json.forEach((key, value) {
      fieldErrors[key] = List<String>.from(value);
    });
    return ValidationError(fieldErrors: fieldErrors);
  }

  @override
  List<String> generateMessages() {
    List<String> messages = [];
    fieldErrors.forEach((key, value) {
      messages.add('$key: ${value.join(', ')}');
    });
    return messages;
  }
}
