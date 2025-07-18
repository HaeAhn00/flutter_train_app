import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SeatPage extends StatefulWidget {
  final String departureStation;
  final String arrivalStation;

  const SeatPage({
    super.key,
    required this.departureStation,
    required this.arrivalStation,
  });

  @override
  State<SeatPage> createState() => SeatPageState();
}

class SeatPageState extends State<SeatPage> {
  // 선택된 좌석을 관리하기 위한 Set
  final Set<int> selectedSeats = {};

  Widget buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget buildSeatItem(int seatIndex) {
    final isSelected = selectedSeats.contains(seatIndex);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSeats.remove(seatIndex);
          } else {
            selectedSeats.add(seatIndex);
          }
        });
      },
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey[300]!,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String getSeatLabel(int seatIndex) {
    final int rowIndex = seatIndex ~/ 4;
    final int colIndex = seatIndex % 4;
    final String rowLabel = '${rowIndex + 1}';
    final String colLabel = String.fromCharCode('A'.codeUnitAt(0) + colIndex);
    return '$rowLabel$colLabel';
  }

  void showBookingConfirmationDialog() {
    if (selectedSeats.isEmpty) {
      return; // 선택된 좌석이 없으면 아무것도 하지 않음
    }

    // 좌석 번호를 정렬하여 일관성 있게 표시
    final sortedSeats = selectedSeats.toList()..sort();
    final seatLabels = sortedSeats.map(getSeatLabel).join(', ');

    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('예매하시겠습니까?'),
        content: Text('선택한 좌석: $seatLabels'),
        actions: [
          CupertinoDialogAction(
            child: const Text('취소'),
            onPressed: () => Navigator.pop(dialogContext), // 다이얼로그 닫기
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('확인'),
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.isFirst), // HomePage로 이동
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('${widget.departureStation} → ${widget.arrivalStation}'),
        title: const Text('좌석 선택'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 출발역과 도착역 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.departureStation,
                  style: const TextStyle(
                    fontSize: 30, // 글자 크기
                    fontWeight: FontWeight.bold, // 글자 두께
                    color: Colors.purple, // 글자 색상
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 30,
                  ),
                ),
                Text(
                  widget.arrivalStation,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 좌석 상태 안내 레이블
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLegendItem(Colors.purple, '선택됨'),
                const SizedBox(width: 20),
                buildLegendItem(Colors.grey[300]!, '선택안됨'),
              ],
            ),
            const SizedBox(height: 16),
            // 좌석 리스트
            // 열 라벨 (A, B, C, D)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 각 좌석의 너비(50)와 좌우 여백(2+2)을 더한 값(54)을 너비로 지정하여 정렬
                Container(
                  width: 54,
                  alignment: Alignment.center,
                  child: const Text('A', style: TextStyle(fontSize: 18)),
                ),
                Container(
                  width: 54,
                  alignment: Alignment.center,
                  child: const Text('B', style: TextStyle(fontSize: 18)),
                ),
                // 행 번호가 들어갈 공간과 동일한 너비
                const SizedBox(width: 50),
                Container(
                  width: 54,
                  alignment: Alignment.center,
                  child: const Text('C', style: TextStyle(fontSize: 18)),
                ),
                Container(
                  width: 54,
                  alignment: Alignment.center,
                  child: const Text('D', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, rowIndex) {
                  final rowLabel = '${rowIndex + 1}';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildSeatItem(rowIndex * 4 + 0),
                      buildSeatItem(rowIndex * 4 + 1),
                      // const SizedBox(width: 20), // 통로
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                            child: Text(
                          rowLabel,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                      ),
                      buildSeatItem(rowIndex * 4 + 2),
                      buildSeatItem(rowIndex * 4 + 3),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // 예매 하기 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: showBookingConfirmationDialog,
              child: const Text(
                '예매 하기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
