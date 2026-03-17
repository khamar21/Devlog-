import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/gold_bottom_nav.dart';
import '../dashboard/dashboard_page.dart';

import '../tasks/tasks_list_page.dart';
import '../profile/profile_page.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key});
  static const routeName = '/project-detail';

  @override
  Widget build(BuildContext context) {
    final total = 120;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Project Phoenix",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.more_vert, color: Colors.black),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFACC15),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7), // light yellow card
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 60,
                              sections: [
                                PieChartSectionData(
                                  value: 45,
                                  color: const Color(0xFFF59E0B), // amber-500
                                  radius: 30,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: 40,
                                  color: const Color(0xFFFACC15), // yellow-400
                                  radius: 30,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: 35,
                                  color: const Color(0xFFFDE68A), // yellow-300
                                  radius: 30,
                                  showTitle: false,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$total h",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Total Hours",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Time Breakdown",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              _StackRow("Firebase", 45, 37.5, const Color(0xFFF59E0B)),
              _StackRow("Flutter UI", 40, 33.3, const Color(0xFFFACC15)),
              _StackRow("Node.js API", 35, 29.2, const Color(0xFFFBBF24)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GoldBottomNav(
        accent: const Color(0xFFF4C430),
        items: const [
          GoldNavItem(icon: Icons.home_rounded, label: "Dashboard"),
          GoldNavItem(icon: Icons.folder_open, label: "Projects"),
          GoldNavItem(icon: Icons.list_alt_rounded, label: "Tasks"),
          GoldNavItem(icon: Icons.person, label: "Profile"),
        ],
        current: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const DashboardPage()));
          } else if (i == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProjectDetailPage()));
          } else if (i == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const TasksListPage()));
          } else if (i == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
        },
      ),
    );
  }

  Widget _StackRow(String name, double hours, double pct, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCE8), // softer yellow for item cards
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$hours h",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "${pct.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
