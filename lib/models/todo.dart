import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

// Uuid _uuid = Uuid();

@freezed
abstract class Todo with _$Todo {
  @JsonSerializable(explicitToJson: true)
  const factory Todo({
    // so the string needs to be there
    required final String id,
    required final String description,
    @Default(false) final bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
