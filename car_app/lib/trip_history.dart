import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  final List<TripItem> _tripData = [
    TripItem(
      tripNumber: "Trip 1",
      date: "Jan 15, 2025",
      distance: "5.2 km",
      duration: "15 min",
      cost: "\$12.50",
    ),
  ];

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
      body: SingleChildScrollView(
        child: Column(
          children: _tripData.asMap().entries.map((entry) {
            final int index = entry.key;
            final TripItem trip = entry.value;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.grey[800]!.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ExpansionTile(
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    trip.isExpanded = expanded;
                  });
                },
                leading: AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: trip.isExpanded ? 0.5 : 0,
                  child: SvgPicture.asset(
                    'assets/arrow-down-s-line.svg',
                    color: Colors.white,
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      '${trip.tripNumber}  :',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 50),
                    Text(
                      trip.date,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTripDetail('Distance', trip.distance),
                        _buildTripDetail('Duration', trip.duration),
                        _buildTripDetail('Cost', trip.cost),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget _buildTripDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class TripItem {
  TripItem({
    required this.tripNumber,
    required this.date,
    required this.distance,
    required this.duration,
    required this.cost,
    this.isExpanded = false,
  });

  final String tripNumber;
  final String date;
  final String distance;
  final String duration;
  final String cost;
  bool isExpanded;
}