import 'package:wolvesrun/models/Laravel.dart';

class LaravelError extends Laravel{
  final String message;
  final Map<String, dynamic> errors;

  LaravelError({required this.message, required this.errors});

  factory LaravelError.fromJson(Map<String, dynamic> json) {
    return LaravelError(
      message: json['message'] ?? 'Unknown error',
      errors: json['errors'] ?? {},
    );
  }

  @override
  String toString() {
    return 'Error: $message\nDetails: $errors';
  }

  @override
  List<String> generateMessages() {
    List<String> messages = [];
    errors.forEach((key, value) {
      if (value is List) {
        for (var element in value) {
          messages.add('$element');
        }
      } else {
        messages.add('$value');
      }
    });
    return messages;
  }
}