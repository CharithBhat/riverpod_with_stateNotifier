import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_dummy/models/todo.dart';
import 'package:riverpod_dummy/views/todo.vm.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: Home(),
      ),
    );
  }
}

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodos);
    final newTodoController = useTextEditingController();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            children: [
              // todo title
              TextField(
                controller: newTodoController,
                decoration:
                    const InputDecoration(labelText: 'What needs to be done?'),
                onSubmitted: (value) {
                  ref.read(todoListProvider.notifier).add(value);
                  newTodoController.clear();
                },
              ),
              const SizedBox(height: 42),
              Column(
                children: [
                  // Tool bar
                  // todo list
                  if (todos.isNotEmpty) const Divider(height: 0),
                  for (int i = 0; i < todos.length; i++) ...[
                    if (i > 0) const Divider(height: 0),
                    Dismissible(
                      key: ValueKey(todos[i].id),
                      onDismissed: (_) {
                        ref.read(todoListProvider.notifier).remove(todos[i]);
                      },
                      child: TodoItem(
                        todo: todos[i],
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('ToolBar');
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

class TodoItem extends HookConsumerWidget {
  const TodoItem({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final todo = ref.watch(_currentTodo);
    final itemFocusNode = useFocusNode();
    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            textEditingController.text = todo.description;
          } else {
            // Commit changes only when the textfield is unfocused, for performance
            ref
                .read(todoListProvider.notifier)
                .edit(id: todo.id, description: textEditingController.text);
          }
        },
        child: ListTile(
          onTap: () {
            itemFocusNode.requestFocus();
            textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value) =>
                ref.read(todoListProvider.notifier).toggle(todo.id),
          ),
          title: isFocused
              ? TextField(
                  autofocus: true,
                  focusNode: textFieldFocusNode,
                  controller: textEditingController,
                )
              : Text(todo.description),
        ),
      ),
    );
  }
}
