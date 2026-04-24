import 'package:flutter/material.dart';

void main() {
  runApp(TodoList());
}

class TodoItem {
 TodoItem({required this.title, this.isDone = false});
 final String title;
 bool isDone;
}

class TodoList extends StatefulWidget {
  const TodoList ({super.key});

   @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // manage list
  List<TodoItem> myItems = [
    TodoItem(title: 'study', isDone: true),
    TodoItem(title: 'eat', isDone: false),
    TodoItem(title: 'sleep', isDone: false),
  ];

  // control keyboard
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("To do list")),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.all(20), 
              child: Row(
                children: [
                  Expanded(child: 
                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'what do you want to do?',
                      ),
                    )
                  ),
                  ElevatedButton(onPressed: () {
                    if (textController.text.isNotEmpty) {
                      setState(() {
                        myItems.add(TodoItem(title: textController.text));
                        textController.clear();
                      });
                    }
                  }, child: Text('Add')),
                ],
              ),
            ),
            Text(
              'You have ${myItems.length} item(s) to do', 
              style: TextStyle(fontWeight: FontWeight.bold,),
            ),
            Expanded (
              child: ListView.builder(
                itemCount: myItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: myItems[index].isDone 
                       ? Icon(Icons.check_circle)
                       : Icon(Icons.radio_button_unchecked),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            myItems.removeAt(index);
                          });
                        },
                      ),
                      title: Text(
                      myItems[index].title, 
                      style: TextStyle(
                        decoration: myItems[index].isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,)),
                      onTap: () {
                        setState(() {
                          // myItems.removeAt(index);
                          myItems[index].isDone = !myItems[index].isDone;
                        });
                      },
                    ),
                  );
                },
              )
            ),
          ]
        ),
      ),
    );
  }
}
