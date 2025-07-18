import 'package:flutter/material.dart';
import 'package:flutter_train_app/data/stations.dart';

class StationListPage extends StatelessWidget {
  final bool isDeparture;
  final String? excludedStation;

  const StationListPage({
    super.key,
    required this.isDeparture,
    this.excludedStation,
  });

  @override
  Widget build(BuildContext context) {
    final filteredStations =
        stations.where((station) => station != excludedStation).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(isDeparture ? '출발역 선택' : '도착역 선택'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: filteredStations.length,
        itemBuilder: (context, index) {
          final station = filteredStations[index];
          return Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: ListTile(
              title: Text(
                station,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context, station);
              },
            ),
          );
        },
      ),
    );
  }
}
