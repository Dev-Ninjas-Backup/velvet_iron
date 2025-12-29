



import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';

class TodoSection extends StatelessWidget {
  const TodoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "To-do Lists",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gold),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Text("Today", style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _TodoTile(
            title: "Breakfast",
            sub: "350 kcal",
            time: "Wed - 8:30 AM",
            icon: Icons.free_breakfast),
        _TodoTile(
            title: "Ozempic (4mg)",
            sub: "1 Injection",
            time: "Wed - 09:30 AM",
            icon: Icons.medication),
      ],
    );
  }
}

class _TodoTile extends StatefulWidget {
  final String title, sub, time;
  final IconData icon;
  const _TodoTile(
      {required this.title,
      required this.sub,
      required this.time,
      required this.icon});

  @override
  State<_TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<_TodoTile> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value ?? false;
              });
            },
            shape: const CircleBorder(),
            activeColor: AppColors.gold,
            checkColor: Colors.black,
            side: const BorderSide(color: Colors.white),
          ),
          const SizedBox(width: 8),
          Icon(widget.icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: const TextStyle(color: Colors.white)),
                Text(widget.sub,
                    style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("+10 XP ⭐", style: TextStyle(color: AppColors.gold)),
              const SizedBox(height: 4),
              Text(widget.time,
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }
}
