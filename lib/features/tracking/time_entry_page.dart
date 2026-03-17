import 'package:flutter/material.dart';

class TimeEntryPage extends StatefulWidget {
  const TimeEntryPage({super.key});
  static const routeName = '/time-entry';

  @override
  State<TimeEntryPage> createState() => _TimeEntryPageState();
}

class _TimeEntryPageState extends State<TimeEntryPage> {
  bool isRunning = false;
  Duration elapsed = Duration.zero;
  late final Stopwatch stopwatch;
  late final ticker = Ticker((_) {
    if (stopwatch.isRunning) {
      setState(() => elapsed = stopwatch.elapsed);
    }
  });

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hh = elapsed.inHours.toString().padLeft(2, '0');
    final mm = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text("Time Entry")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB300),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const SizedBox(height: 40),
          Text("$hh:$mm:$ss", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                stopwatch.start();
                setState(() => isRunning = true);
              },
              child: const Text("Start"),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                stopwatch.stop();
                setState(() => isRunning = false);
              },
              child: const Text("End"),
            ),
          ]),
          const SizedBox(height: 24),
          const TextField(decoration: InputDecoration(labelText: "Project")),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: "Description")),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: "Tech Stack")),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300), minimumSize: const Size(double.infinity, 48)),
            child: const Text("Log Time"),
          ),
        ]),
      ),
    );
  }
}

class Ticker {
  final void Function(Duration) onTick;
  bool _running = false;
  Ticker(this.onTick);

  void start() async {
    _running = true;
    while (_running) {
      await Future.delayed(const Duration(seconds: 1));
      onTick(Duration.zero);
    }
  }

  void stop() => _running = false;
  void dispose() => _running = false;
}
