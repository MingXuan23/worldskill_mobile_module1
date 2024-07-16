import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:worldskill_module1/model/ticket.dart';
import 'package:worldskill_module1/page/TicketCreatePage.dart';
import 'package:worldskill_module1/page/TicketDetailPage.dart';
import 'package:worldskill_module1/services/ApiService.dart';

class TicketRow extends StatelessWidget {
  const TicketRow({super.key, required this.ticket, required this.func});
  final Ticket ticket;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>  TicketDetailPage(ticket: ticket)));
        },
        child: Dismissible(
          onDismissed: (direction) async {
            int code = await ApiService.deleteTicket(ticket.id);

            if (code == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Delete ticket successfully')));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Error')));
            }
            func();
            // Handle dismiss action if needed
          },
          key: Key(ticket.name), // Unique key for each item
          direction: DismissDirection.horizontal,
          child: Container(
            decoration: BoxDecoration(color: Colors.black12),
            margin: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * 0.60,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ticket.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(ticket.seat)],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
