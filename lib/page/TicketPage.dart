import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:worldskill_module1/model/ticket.dart';
import 'package:worldskill_module1/page/TicketCreatePage.dart';
import 'package:worldskill_module1/services/ApiService.dart';
import 'package:worldskill_module1/widget/ticketRow.dart';

class TicketTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: ((settings) {
          return MaterialPageRoute(builder: (context) => TicketPage());
        }),
      ),
    );
  }
}

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  List<Ticket> ticketList = [];

  Future<void> getTicketList() async {
    ticketList = await ApiService.getTickets();

    var position = await Ticket.getPosition();
    if (position.length != 0) {
      ticketList.sort(((a, b) {
        return position.indexOf(a.id) - position.indexOf(b.id);
      }));
    }
    setState(() {});
  }

  Future<void> redirectCreatePage() async {
    Ticket? ticket = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CreateTicketPage()));
    if (ticket == null) return;

    ticketList.add(ticket);
    await Ticket.storePosition(ticketList);
    await getTicketList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTicketList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text('Tickets List'),
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 245, 245, 128)),
                onPressed: redirectCreatePage,
                child: Text(
                  'Create a new ticket',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Opening Ceremony Ticket',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  // Ensure the index is adjusted correctly
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Ticket item = ticketList.removeAt(oldIndex);
                  ticketList.insert(newIndex, item);
                  setState(() {});
                  Ticket.storePosition(ticketList);
                },
                children: ticketList
                    .where(
                        (ticket) => ticket.type == 'Opening Ceremony Tickets')
                    .map((item) {
                  return TicketRow(
                    ticket: item,
                    key: ValueKey(item),
                    func: getTicketList,
                  );
                }).toList()),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Closing Ceremony Ticket',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  // Ensure the index is adjusted correctly
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Ticket item = ticketList.removeAt(oldIndex);
                  ticketList.insert(newIndex, item);
                  setState(() {});
                },
                children: ticketList
                    .where(
                        (ticket) => ticket.type == 'Closing Ceremony Tickets')
                    .map((item) {
                  return TicketRow(
                    ticket: item,
                    key: ValueKey(item),
                    func: getTicketList,
                  );
                }).toList()),
          )
        ],
      ),
    );
  }
}
