import 'package:devlog_flutter_ui/data/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/gold_bottom_nav.dart';
import '../dashboard/dashboard_page.dart';
import '../tasks/tasks_list_page.dart';
import '../profile/profile_page.dart';

class ProjectDetailGoldPage extends StatefulWidget {
  const ProjectDetailGoldPage({
    super.key,
    this.projectProgress = 0.75,
    this.progressLabel = 'Project Progress',
  });
  static const routeName = '/project-detail-gold';

  final double projectProgress;
  final String progressLabel;

  @override
  State<ProjectDetailGoldPage> createState() => _ProjectDetailGoldPageState();
}

class _ProjectDetailGoldPageState extends State<ProjectDetailGoldPage> {
  final List<Map<String, String>> tasks = [
    {"title": "Authentication endpoints finalized", "time": "Today, 10:30 AM"},
    {"title": "Documentation updated", "time": "Yesterday, 4:15 PM"},
    {"title": "API deployed to staging", "time": "2 days ago"},
  ];

  // TODO: receive/set actual projectId and userId via constructor/route
  final String _projectId = 'CURRENT_PROJECT_ID';
  final String? _userId = 'CURRENT_USER_ID';

  @override
  void initState() {
    super.initState();
    _loadActivity();
  }

  Future<void> _loadActivity() async {
    try {
      final logs = await ApiService.getLogsByProject(
        projectId: _projectId,
        userId: _userId,
      );
      setState(() {
        tasks
          ..clear()
          ..addAll(logs.map((l) => {
                'title': l['title']?.toString() ?? 'Log',
                'time': l['time']?.toString() ?? '',
              }));
      });
    } catch (e) {
      // keep existing UI on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load activity: $e')),
      );
    }
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final timeController = TextEditingController();

        return AlertDialog(
          title: const Text("Add New Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: "Time",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    timeController.text.isNotEmpty) {
                  setState(() {
                    tasks.add({
                      "title": titleController.text,
                      "time": timeController.text,
                    });
                  });
                  try {
                    // Replace with real ids from your app context
                    final userId =
                        'CURRENT_USER_ID_OR_SESSION'; // pass real user id
                    final projectId =
                        'CURRENT_PROJECT_ID'; // pass real project id
                    await ApiService.logTime(
                      userId: userId,
                      projectId: projectId,
                      stack: 'General',
                      hours: 1.0,
                      description: titleController.text,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to log time: $e')),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFFF4C430);
    final accentDark = const Color(0xFFD4A017);
    final normalizedProgress = widget.projectProgress.clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Project Details",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.more_vert, color: Color(0xFF0F172A)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              _ProjectHeaderCard(
                accent: accent,
                accentDark: accentDark,
                progress: normalizedProgress,
              ),
              const SizedBox(height: 24),
              // Progress chart
              _ProgressChart(
                accent: accent,
                accentDark: accentDark,
                progress: normalizedProgress,
                progressLabel: widget.progressLabel,
              ),
              const SizedBox(height: 24),
              // Time tracking cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.timer_outlined,
                      label: "Total Hours",
                      value: "120h",
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.task_alt,
                      label: "Tasks Done",
                      value: "${tasks.length}/17",
                      color: const Color(0xFF22C55E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Activity Timeline",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              ...tasks.map((task) => _TimelineRow(
                    icon: Icons.check_circle,
                    color: accent,
                    title: task["title"]!,
                    time: task["time"]!,
                  )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accent,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _addNewTask,
      ),
      bottomNavigationBar: GoldBottomNav(
        accent: accent,
        items: const [
          GoldNavItem(icon: Icons.home_rounded, label: "Dashboard"),
          GoldNavItem(icon: Icons.folder_open, label: "Projects"),
          GoldNavItem(icon: Icons.list_alt_rounded, label: "Tasks"),
          GoldNavItem(icon: Icons.person, label: "Profile"),
        ],
        current: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TasksListPage()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }
}

// Project header card
class _ProjectHeaderCard extends StatelessWidget {
  final Color accent;
  final Color accentDark;
  final double progress;

  const _ProjectHeaderCard({
    required this.accent,
    required this.accentDark,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accentDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.folder_open,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phoenix API Refactor",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due: March 15, 2024",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _ChipTag(label: "Backend", color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(width: 8),
              _ChipTag(label: "API", color: Colors.white.withValues(alpha: 0.3)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipTag extends StatelessWidget {
  final String label;
  final Color color;
  const _ChipTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Progress donut chart
class _ProgressChart extends StatelessWidget {
  final Color accent;
  final Color accentDark;
  final double progress;
  final String progressLabel;

  const _ProgressChart({
    required this.accent,
    required this.accentDark,
    required this.progress,
    required this.progressLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 140,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 14,
                valueColor: AlwaysStoppedAnimation(accentDark),
                backgroundColor: accent.withValues(alpha: 0.15),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).round()}%',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  progressLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  const _TimelineRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
