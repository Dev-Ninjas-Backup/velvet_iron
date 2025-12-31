import 'package:flutter/material.dart';

class DoseHistorySection extends StatelessWidget {
  const DoseHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dose History',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 12),
        _item('Ozempic (4mg)', 'Wed - 09:30 AM'),
        _item('Metformin (400mg)', 'Tue - 08:10 AM'),
      ],
    );
  }

  Widget _item(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff5B1616),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(time, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
