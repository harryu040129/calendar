import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calendar_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Text', // Use Cupertino fonts
      ),
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Harry',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'You have 4 tasks due Today',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Padding( // When the layout is prioritized, use Padding widget to efficiently add padding
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(CupertinoIcons.calendar, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: HomeBody(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar with filter button
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.search),
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // "Today" section with tasks
          Text(
            'Today',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AUGUST 19, 2022',
                style: TextStyle(color: Colors.grey),
              ),
              Icon(CupertinoIcons.calendar, color: Colors.grey),
            ],
          ),
          SizedBox(height: 10),
          TaskCard(
            title: 'Figma App Design',
            date: '19 August 2024',
            progress: 0.45,
            //members: ['assets/avatar1.png', 'assets/avatar2.png', 'assets/avatar3.png'],
          ),
          TaskCard(
            title: 'Machine Learning process',
            date: '19 August 2024',
            progress: 0.75,
            //members: ['assets/avatar1.png', 'assets/avatar2.png'],
          ),
          SizedBox(height: 20),

          // "All Task" section
          Text(
            'All Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TaskCard(
            title: 'Ongoing',
            date: '10 Tasks',
            isOngoing: true,
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String date;
  final double progress;
  final List<String>? members; // Nullable list
  final bool isOngoing;

  TaskCard({
    required this.title,
    required this.date,
    this.progress = 0,
    this.members,
    this.isOngoing = false,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            date,
            style: TextStyle(color: Colors.grey),
          ),
          if (!isOngoing) ...[
            SizedBox(height: 15),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
            ),
            SizedBox(height: 10),
            if (members != null && members!.isNotEmpty) // Check if members is not null and not empty
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: members!.map((avatar) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(avatar),
                          radius: 15,
                        ),
                      );
                    }).toList(),
                  ),
                  Text('${(progress * 20).toInt()}/20 Finished'),
                ],
              ),
          ],
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chart_bar_alt_fill),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.add_circled_solid, size: 40, color: Colors.green),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.calendar),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings),
          label: '',
        ),
      ],
    );
  }
}