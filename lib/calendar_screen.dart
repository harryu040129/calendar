import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CalendarBody(),
    );
  }
}

class CalendarBody extends StatefulWidget {
  @override
  _CalendarBodyState createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  bool showMonthView = false; // Toggle for month/week view
  ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now()); // Initialize with today's date

  List<Map<String, String>> tasks = [ // List to hold task details
    {'time': '07:00 - 09:00', 'title': 'Figma Design'},
    {'time': '09:00 - 12:00', 'title': 'Add MachineLearning'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: CalendarTitle(selectedDate: selectedDate), // Pass ValueNotifier directly
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.calendar, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // Calendar View
            GestureDetector(
              onTap: () {
                setState(() {
                  showMonthView = !showMonthView; // Toggle calendar view
                });
              },
              child: showMonthView ? buildMonthView() : buildWeekView(),
            ),
            SizedBox(height: 20),

            // Task Cards for the selected date
            ...tasks.asMap().entries.map((entry) {
              int idx = entry.key;
              var task = entry.value;
              return TaskCard(
                time: task['time']!,
                title: task['title']!,
                onEdit: (newTitle, newTime) {
                  setState(() {
                    tasks[idx]['title'] = newTitle; // Update task title
                    tasks[idx]['time'] = newTime;   // Update task time
                  });
                },
                onDelete: () {
                  setState(() {
                    tasks.removeAt(idx); // Delete the task from the list
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskDialog(context);
        },
        child: Icon(CupertinoIcons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Function to show dialog to add a new task
  void showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Task Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  tasks.add({'title': titleController.text, 'time': timeController.text}); // Add new task
                });
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Build week view for the calendar with the selected date in the center
  Widget buildWeekView() {
    // Ensure the selected date is centered in the week view
    DateTime startOfWeek = selectedDate.value.subtract(Duration(days: 3)); // Start 3 days before the selected date

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(7, (index) {
          DateTime day = startOfWeek.add(Duration(days: index)); // Calculate each day in the week
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  DateFormat('E').format(day), // Display day of the week
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                if (day.day == selectedDate.value.day && day.month == selectedDate.value.month) // Highlight the selected date
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Improved design for month view of the calendar
  Widget buildMonthView() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: List.generate(5, (row) { // Improved layout for more realistic month
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (col) {
                final day = DateTime(selectedDate.value.year, selectedDate.value.month, (row * 7) + col + 1);
                if (day.month != selectedDate.value.month) return SizedBox(width: 40); // Skip days not in the current month

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate.value = day; // Update selected date using ValueNotifier
                      showMonthView = false; // Switch back to week view
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: day.day == selectedDate.value.day ? Colors.green : Colors.white, // Highlight selected day
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (day.day == selectedDate.value.day)
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                      ],
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: day.day == selectedDate.value.day ? Colors.white : Colors.black,
                        fontWeight: day.day == selectedDate.value.day ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

// Separate widget to manage calendar title update
class CalendarTitle extends StatelessWidget {
  final ValueNotifier<DateTime> selectedDate; // Receive ValueNotifier directly

  CalendarTitle({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDate, // Listen to changes in selectedDate
      builder: (context, selectedDate, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMMM d').format(selectedDate), // Dynamically update the title based on selected date
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '10 tasks today',  // Example subtitle; can be updated dynamically if needed
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        );
      },
    );
  }
}

// TaskCard widget to show task details
class TaskCard extends StatelessWidget {
  final String time;
  final String title;
  final Function(String, String) onEdit; // Callback for edit action
  final VoidCallback onDelete; // Callback for delete action

  TaskCard({
    required this.time,
    required this.title,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
    margin: EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    blurRadius: 10,
      offset: Offset(0, 5),
    ),
    ],
    ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(CupertinoIcons.clock, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit button
          IconButton(
            icon: Icon(CupertinoIcons.pencil, color: Colors.black),
            onPressed: () {
              showEditDialog(context);
            }, // Show edit dialog
          ),
          // Delete button
          IconButton(
            icon: Icon(CupertinoIcons.trash, color: Colors.red),
            onPressed: onDelete, // Callback function when delete button is pressed
          ),
        ],
      ),
    );
  }

  // Function to show edit dialog
  void showEditDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text: title);
    final TextEditingController timeController = TextEditingController(text: time);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Task Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                onEdit(titleController.text, timeController.text); // Pass new values back
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }
}