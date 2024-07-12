import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:worldskill_module1/model/event.dart';
import 'package:worldskill_module1/services/ApiService.dart';
import 'package:worldskill_module1/widget/EventCard.dart';

class EventTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: ((settings) {
          return MaterialPageRoute(builder: (context) => EventPage());
        }),
      ),
    );

  }
}

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  Set<String> _selectedOption = {'All'};
  List<Event> eventList = [];

  Future<void> getEventsFromApi() async {
    var list = await ApiService.getEvents();
    setState(() {
      eventList = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getEventsFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: Center(
        child: Text('Event List'),
      )),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SegmentedButton(
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedOption = newSelection;
                  });
                },
                segments: const [
                  ButtonSegment<String>(
                    value: 'All',
                    label: Text('All'),
                  ),
                  ButtonSegment<String>(
                    value: 'Unread',
                    label: Text('Unread'),
                  ),
                  ButtonSegment<String>(
                    value: 'Read',
                    label: Text('Read'),
                  ),
                ],
                selected: _selectedOption,
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  String option = _selectedOption.first;
                  if (option == 'Read' && eventList[index].status != 'Read') {
                    return Container();
                  } else if (option == 'Unread' &&
                      eventList[index].status != 'Unread') {
                    return Container();
                  } else {
                    return EventCard(
                      event: eventList[index],
                      func: getEventsFromApi,
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
