import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primaryColor: Colors.blue, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> todos = [];
  TextEditingController controller = TextEditingController();
  int editingIndex = -1;

  void addTodo() {
    setState(() {
      todos.add(controller.text);
      controller.clear();
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
      if (editingIndex == index) {
        editingIndex = -1;
      }
    });
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index] = todos[index].startsWith('✓ ') ? todos[index].substring(2) : '✓ ' + todos[index];
    });
  }

  void startEditing(int index) {
    setState(() {
      editingIndex = index;
      controller.text = todos[index];
    });
  }

  void saveEditing(int index) {
    setState(() {
      todos[index] = controller.text;
      controller.clear();
      editingIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter a new todo',
            ),
            onSubmitted: (_) => addTodo(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: editingIndex == index
                      ? TextField(
                          controller: controller,
                          onSubmitted: (_) => saveEditing(index),
                        )
                      : Text(todos[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTodo(index),
                      ),
                      IconButton(
                        icon: Icon(editingIndex == index ? Icons.save : Icons.edit),
                        onPressed: () {
                          if (editingIndex == index) {
                            saveEditing(index);
                          } else {
                            startEditing(index);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(todos[index].startsWith('✓ ') ? Icons.check_box : Icons.check_box_outline_blank),
                        onPressed: () => toggleTodo(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
