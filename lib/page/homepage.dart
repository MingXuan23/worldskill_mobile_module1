import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worldskill_module1/page/RecordPage.dart';
import 'package:worldskill_module1/page/TicketPage.dart';
import 'package:worldskill_module1/page/eventpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget page = const EventPage();
  String pagetitle = 'Event List';

  int currentIndex = 0;

  List<Widget> pages = [
    EventTabPage(),
    TicketTabPage(),
    RecordPage()

  ];
  List<String> pageTitles = [
    'Event List',
    'Tickets',
    'Records',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: pages,
        index: currentIndex,
        ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
             currentIndex =index;
          });
        
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Tickets"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Records")
        ],
      ),
    );
  }
}
