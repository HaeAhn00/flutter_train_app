import 'package:flutter/material.dart';
import 'package:flutter_train_app/data/stations.dart';

class StationListPage extends StatelessWidget {
  const StationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기차역 선택'),
      ),
      body: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final station = stations[index];
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
