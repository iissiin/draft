import 'package:equatable/equatable.dart';

class Draft extends Equatable {
  const Draft({required this.id, required this.title, required this.text});

  final int id;
  final String title;
  final String text;

  Draft copyWith({String? title, String? text}) =>
      Draft(id: id, title: title ?? this.title, text: text ?? this.text);

  @override
  List<Object> get props => [id, title, text];
}
