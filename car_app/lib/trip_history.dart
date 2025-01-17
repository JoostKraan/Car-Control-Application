import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
final List<Item> _data = generateItems(8);
List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class _TripHistoryState extends State<TripHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Trip History',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(2),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800]!.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  //color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            height: 50,
                child: Row(
                  children: [
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded){
                        setState(() {
                          _data[index].isExpanded = isExpanded;
                        });
                      },
                      children: [],
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 0, 1, 1),
                      child: IconButton(onPressed: null, icon: SvgPicture.asset(
                        'assets/arrow-down-s-line.svg',
                        color: Colors.white,
                      ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 1, 1),
                      child: Text(
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                          'Trip 1  :'
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 1, 1),
                      child: Text(
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                          'Data'
                      ),
                    ),
                  ],
                )
            ),

        ],
      ),
    );
  }
}

