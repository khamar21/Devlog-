import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/gold_bottom_nav.dart';
import '../dashboard/dashboard_page.dart';
import '../projects/project_detail_gold_page.dart';
import '../profile/profile_page.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});
  static const routeName = '/tasks';

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFFF4C430);
    final accentDark = const Color(0xFFD4A017);

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
          "My Tasks",
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
            child: const Icon(Icons.filter_list, color: Color(0xFF0F172A)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip('All', selectedFilter == 'All', () {
                    setState(() => selectedFilter = 'All');
                  }, accent),
                  _FilterChip('Today', selectedFilter == 'Today', () {
                    setState(() => selectedFilter = 'Today');
                  }, accent),
                  _FilterChip('Upcoming', selectedFilter == 'Upcoming', () {
                    setState(() => selectedFilter = 'Upcoming');
                  }, accent),
                  _FilterChip('Completed', selectedFilter == 'Completed', () {
                    setState(() => selectedFilter = 'Completed');
                  }, accent),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _TaskCard(
                      title: "Complete Project Proposal",
                      description:
                          "Finalize the Q1 project proposal for review",
                      hours: 2,
                      minutes: 12,
                      due: "2024-03-15",
                      priority: "High",
                      accent: accent,
                    ),
                    _TaskCard(
                      title: "Refactor Authentication Module",
                      description:
                          "Update auth system with new security patches",
                      hours: 1,
                      minutes: 45,
                      due: "2024-03-17",
                      priority: "Medium",
                      accent: accent,
                    ),
                    _TaskCard(
                      title: "Database Migration Sprint",
                      description: "Migrate legacy database to PostgreSQL",
                      hours: 3,
                      minutes: 30,
                      due: "2024-03-20",
                      priority: "High",
                      accent: accent,
                    ),
                    _TaskCard(
                      title: "Team Meeting Preparation",
                      description: "Prepare slides and agenda for weekly sync",
                      hours: 1,
                      minutes: 0,
                      due: "2024-03-16",
                      priority: "Low",
                      accent: accent,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [accent, accentDark],
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: GoldBottomNav(
        accent: accent,
        items: const [
          GoldNavItem(icon: Icons.home_rounded, label: "Dashboard"),
          GoldNavItem(icon: Icons.folder_open, label: "Projects"),
          GoldNavItem(icon: Icons.list_alt_rounded, label: "Tasks"),
          GoldNavItem(icon: Icons.person, label: "Profile"),
        ],
        current: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushNamed(context, DashboardPage.routeName);
          } else if (i == 1) {
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

  Widget _FilterChip(
      String label, bool isSelected, VoidCallback onTap, Color accent) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accent : const Color(0xFFFEFCE8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accent : accent.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : const Color(0xFF475569),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatefulWidget {
  final String title;
  final String description;
  final int hours;
  final int minutes;
  final String due;
  final String priority;
  final Color accent;

  const _TaskCard({
    required this.title,
    required this.description,
    required this.hours,
    required this.minutes,
    required this.due,
    required this.priority,
    required this.accent,
  });

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final priorityColor = widget.priority == 'High'
        ? Colors.red[400]!
        : widget.priority == 'Medium'
            ? Colors.orange[400]!
            : Colors.blue[400]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCE8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.accent.withValues(alpha: 0.3), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _checked = !_checked),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _checked ? widget.accent : Colors.transparent,
                    border: Border.all(color: widget.accent, width: 2),
                  ),
                  child: _checked
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                    decoration: _checked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.priority,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text(
                      "${widget.hours}h ${widget.minutes}min",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text(
                      "Due: ${widget.due}",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
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
