import 'package:flutter/material.dart';

class SeatPage extends StatelessWidget {
  const SeatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('좌석 선택'),
      ),
      body: const Center(
        child: Text('좌석 선택 화면입니다.'),
      ),
    );
  }
}
