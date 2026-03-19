import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/tracking/time_entry_page.dart';
import 'features/profile/profile_page.dart';
import 'features/tasks/tasks_list_page.dart';
import 'features/projects/project_detail_gold_page.dart';
import 'data/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApiService.useProd();
  runApp(const ProviderScope(child: DevLogProApp()));
}

class DevLogProApp extends StatelessWidget {
  const DevLogProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevLog Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const DashboardPage(),
      routes: {
        DashboardPage.routeName: (_) => const DashboardPage(),
        TimeEntryPage.routeName: (_) => const TimeEntryPage(),
        ProfilePage.routeName: (_) => const ProfilePage(),
        TasksListPage.routeName: (_) => const TasksListPage(),
        ProjectDetailGoldPage.routeName: (_) => const ProjectDetailGoldPage(),
      },
    );
  }
}
