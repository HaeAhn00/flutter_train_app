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
            _StationHeader(
              departureStation: widget.departureStation,
              arrivalStation: widget.arrivalStation,
            ),
            const SizedBox(height: 16),
            const _SeatLegend(),
            const SizedBox(height: 16),
            Expanded(
              child: _SeatSelectionGrid(
                selectedSeats: selectedSeats,
                onSeatTap: (seatIndex) {
                  setState(() {
                    if (selectedSeats.contains(seatIndex)) {
                      selectedSeats.remove(seatIndex);
                    } else {
                      selectedSeats.add(seatIndex);
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            _BookingButton(onPressed: showBookingConfirmationDialog),
          ],
        ),
      ),
    );
  }
}

/// 출발역과 도착역을 표시하는 헤더 위젯
class _StationHeader extends StatelessWidget {
  const _StationHeader({
    required this.departureStation,
    required this.arrivalStation,
  });

  final String departureStation;
  final String arrivalStation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          departureStation,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
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
          arrivalStation,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }
}

/// 좌석 상태를 안내하는 범례 위젯
class _SeatLegend extends StatelessWidget {
  const _SeatLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.purple, '선택됨'),
        const SizedBox(width: 20),
        _buildLegendItem(Colors.grey[300]!, '선택안됨'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
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
}

/// 좌석 선택 그리드 영역 위젯
class _SeatSelectionGrid extends StatelessWidget {
  const _SeatSelectionGrid({
    required this.selectedSeats,
    required this.onSeatTap,
  });

  final Set<int> selectedSeats;
  final ValueSetter<int> onSeatTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  _SeatBox(
                    isSelected: selectedSeats.contains(rowIndex * 4 + 0),
                    onTap: () => onSeatTap(rowIndex * 4 + 0),
                  ),
                  _SeatBox(
                    isSelected: selectedSeats.contains(rowIndex * 4 + 1),
                    onTap: () => onSeatTap(rowIndex * 4 + 1),
                  ),
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
                  _SeatBox(
                    isSelected: selectedSeats.contains(rowIndex * 4 + 2),
                    onTap: () => onSeatTap(rowIndex * 4 + 2),
                  ),
                  _SeatBox(
                    isSelected: selectedSeats.contains(rowIndex * 4 + 3),
                    onTap: () => onSeatTap(rowIndex * 4 + 3),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 개별 좌석 위젯
class _SeatBox extends StatelessWidget {
  const _SeatBox({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
}

/// 예매하기 버튼 위젯
class _BookingButton extends StatelessWidget {
  const _BookingButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: const Text(
        '예매 하기',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
