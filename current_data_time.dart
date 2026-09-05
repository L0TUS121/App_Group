import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class CurrentDateTime extends StatefulWidget {
  const CurrentDateTime({super.key});

  @override
  State<CurrentDateTime> createState() => _CurrentDateTimeState();
}

class _CurrentDateTimeState extends State<CurrentDateTime> {
  DateTime _now = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(_now);
    final date = DateFormat('EEEE, d MMMM', 'uk_UA').format(_now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        Text(date, style: const TextStyle(fontSize: 17, color: Colors.grey)),
      ],
    );
  }
}
