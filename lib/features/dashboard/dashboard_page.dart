import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../projects/project_detail_gold_page.dart';
import '../tasks/tasks_list_page.dart';
import '../profile/profile_page.dart';
import '../../widgets/gold_bottom_nav.dart';
import '../../data/api_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _TaskCard extends StatefulWidget {
  final int hours;
  final int minutes;
  final String title;
  final String due;
  final Color accent;
  final bool initialChecked;

  const _TaskCard({
    Key? key,
    required this.hours,
    required this.minutes,
    required this.title,
    required this.due,
    required this.accent,
    this.initialChecked = false,
  }) : super(key: key);

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.initialChecked;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.accent.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _checked,
            activeColor: widget.accent,
            onChanged: (val) {
              setState(() {
                _checked = val ?? false;
              });
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                    decoration: _checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: widget.accent),
                    const SizedBox(width: 4),
                    Text(
                      "${widget.hours}h ${widget.minutes}m",
                      style: textTheme.bodySmall?.copyWith(
                        color: widget.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.due,
                      style: textTheme.bodySmall?.copyWith(
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
    );
  }
}

class _DashboardPageState extends State<DashboardPage> {
  final List<DateTime> _dates =
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  int _selectedIndex = 0;
  int? _weeklyHours;

  // 🔑 TEMP user id (replace with logged-in user id)
  final String userId = "1";

  @override
  void initState() {
    super.initState();
    _loadWeekly();
  }

  Future<void> _loadWeekly() async {
    try {
      final report = await ApiService.getWeeklyReport(userId);
      setState(() {
        _weeklyHours = (report['totalHours'] as num?)?.toInt();
      });
    } catch (e) {
      debugPrint("Weekly report error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFFF4C430);
    final accentDark = const Color(0xFFD4A017);
    final textTheme = GoogleFonts.interTextTheme();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          "Dashboard",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _ProfileCard(accent: accent, accentDark: accentDark),
              const SizedBox(height: 24),

              _DateSelector(
                dates: _dates,
                selected: _selectedIndex,
                onSelect: (i) => setState(() => _selectedIndex = i),
                accent: accent,
              ),

              const SizedBox(height: 24),

              _WeeklySummaryCardGold(
                accent: accent,
                accentDark: accentDark,
                hoursTextOverride:
                    _weeklyHours != null ? "${_weeklyHours}h" : "--",
              ),

              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Tasks",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _TaskCard(
                hours: 2,
                minutes: 12,
                title: "Complete Project Proposal",
                due: "2024-03-15",
                accent: accent,
                initialChecked: true,
              ),

              const SizedBox(height: 16),

              _TaskCard(
                hours: 1,
                minutes: 45,
                title: "Refactor Authentication Module",
                due: "2024-03-17",
                accent: accent,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GoldBottomNav(
        accent: accent,
        items: const [
          GoldNavItem(icon: Icons.home_rounded, label: "Dashboard"),
          GoldNavItem(icon: Icons.folder_open, label: "Projects"),
          GoldNavItem(icon: Icons.list_alt_rounded, label: "My Task"),
          GoldNavItem(icon: Icons.person_rounded, label: "Profile"),
        ],
        current: 0,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushNamed(context, ProjectDetailGoldPage.routeName);
          } else if (i == 2) {
            Navigator.pushNamed(context, TasksListPage.routeName);
          } else if (i == 3) {
            Navigator.pushNamed(context, ProfilePage.routeName);
          }
        },
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final List<DateTime> dates;
  final int selected;
  final ValueChanged<int> onSelect;
  final Color accent;

  const _DateSelector({
    Key? key,
    required this.dates,
    required this.selected,
    required this.onSelect,
    required this.accent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final date = dates[i];
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? accent : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? accent : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${date.day}/${date.month}",
                    style: textTheme.bodyMedium?.copyWith(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1],
                    style: textTheme.bodySmall?.copyWith(
                      color: isSelected ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class   _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.accent,
    required this.accentDark,
  });

  final Color accent;
  final Color accentDark;

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: accentDark.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Jane Doe",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Welcome back!",
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklySummaryCardGold extends StatelessWidget {
  final Color accent;
  final Color accentDark;
  final String hoursTextOverride;

  const _WeeklySummaryCardGold({
    Key? key,
    required this.accent,
    required this.accentDark,
    required this.hoursTextOverride,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentDark.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.bar_chart_rounded, color: accentDark, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Weekly Summary",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accentDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total hours logged this week",
                  style: textTheme.bodyMedium?.copyWith(
                    color: accentDark.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            hoursTextOverride,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: accentDark,
            ),
          ),
        ],
      ),
    );
  }
}
