import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/add_page.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoListPage extends StatefulWidget {
  
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  List filteredList = [];

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = items;
    } else {
      results = items
          .where((item) =>
              item['title']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              item['description']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredList = results;
    });
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
        filteredList = items;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
        filteredList = items;
      });
    } else {
      showErrorMessage('Unable to Delete');
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    final result = await Navigator.push(context, route);

    if (result != null && result is bool && result) {
      setState(() {
        isLoading = true;
      });
      fetchTodo();
    }
  }

  void navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    final result = await Navigator.push(context, route);

    if (result != null && result is bool && result) {
      setState(() {
        isLoading = true;
      });
      fetchTodo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo App',
          style: TextStyle(color: Colors.black),
          ),
        backgroundColor: Color(0xFFB4D4FF),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: filteredList.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: searchBox(),
                ),
                calendar(), // Menambahkan calendarCard
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final item = filteredList[index] as Map;
                      final id = item['_id'];
                      final isCompleted = item['is_completed'] ?? false;
                      return Card(
                        color: Color(0xFFB4D4FF),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                            backgroundColor: Color(0xFF7FB5FF),
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: item['is_completed'] ? item['title'] : '',
                              style: item['is_completed']
                                  ? TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                    )
                                  : TextStyle(
                                    ),
                              children: [
                                if (!item['is_completed'])
                                  TextSpan(
                                    text: item['title'],
                                    style: TextStyle(),
                                  ),
                              ],
                            ),
                          ),
                          subtitle: Text(item['description']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: isCompleted,
                                onChanged: (value) {
                                  updateCompletionStatus(id, !isCompleted);
                                },
                                activeColor: Color(0xFF45A834),
                              ),
                              PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    navigateToEditPage(item);
                                  } else if (value == 'delete') {
                                    deleteById(id);
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text('Edit'),
                                      value: 'edit',
                                    ),
                                    PopupMenuItem(
                                      child: Text('Delete'),
                                      value: 'delete',
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            navigateToEditPage(item);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF001D6E),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFFFFDD95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.black),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

    Widget calendar() {
    return Column(
      children: [
        Container(
          child: TableCalendar(
            rowHeight: 43,
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime(2030, 3, 14),
            onDaySelected: _onDaySelected,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF9843), // Warna today: #ff9843
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFDDA9), // Warna selected day: #ffdda9
              ),
              todayTextStyle: TextStyle(
              color: Colors.black, // Warna teks hari ini
              fontWeight: FontWeight.bold, // Bold teks hari ini
            ),
            selectedTextStyle: TextStyle(
              color: Colors.black, // Warna teks selected day
              fontWeight: FontWeight.bold, // Bold teks selected day
            ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> updateCompletionStatus(String id, bool value) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode({"is_completed": value}),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        final updatedList = List.from(items);
        final index = updatedList.indexWhere((element) => element['_id'] == id);
        if (index != -1) {
          updatedList[index]['is_completed'] = value;
          items = updatedList;
        }
      });
    } else {
      print('HTTP error: ${response.statusCode}');
      showErrorMessage('Failed to update completion status');
    }
  }
}