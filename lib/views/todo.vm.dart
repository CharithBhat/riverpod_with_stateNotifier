import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/todo.dart';
import 'package:uuid/uuid.dart';
// import 'package:meta/meta.dart';

const uid = Uuid();

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList([
    Todo(id: uid.v4(), description: 'learning'),
    Todo(id: uid.v4(), description: 'RiverPod'),
    Todo(id: uid.v4(), description: 'Right now'),
  ]);
});

enum TodoListFilter {
  all,
  active,
  completed,
}

final todoListFilter = StateProvider((ref) {
  return TodoListFilter.all;
});

final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);
});

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  void add(String description) {
    state = [
      ...state,
      Todo(
        id: uid.v4(),
        description: description,
      ),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
              id: todo.id,
              completed: !todo.completed,
              description: todo.description)
        else
          todo,
    ];
  }

  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
