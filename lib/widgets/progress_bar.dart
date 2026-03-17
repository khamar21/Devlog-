
import 'package:flutter/material.dart';

class LogCard extends StatelessWidget {
  final String date;
  final String project;
  final String stacks;
  final double hours;
  final String note;
  const LogCard({
    super.key,
    required this.date,
    required this.project,
    required this.stacks,
    required this.hours,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(
            width: 6,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(project, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${hours.toStringAsFixed(1)}h'),
                  ]),
                  const SizedBox(height: 6),
                  Text(stacks, style: const TextStyle(color: Colors.black54)),
                  Text(note),
                  Text(date, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ]),
          )
        ]),
      ),
    );
  }
}
