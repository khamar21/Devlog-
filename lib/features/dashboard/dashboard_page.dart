import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../projects/project_detail_gold_page.dart';
import '../tasks/tasks_list_page.dart';
import '../profile/profile_page.dart';
import '../../widgets/gold_bottom_nav.dart';
import '../../data/api_service.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});
  static const routeName = '/dashboard';

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

@immutable
class DashboardTask {
  const DashboardTask({
    required this.hours,
    required this.minutes,
    required this.title,
    required this.due,
    this.checked = false,
  });

  final int hours;
  final int minutes;
  final String title;
  final String due;
  final bool checked;

  DashboardTask copyWith({bool? checked}) {
    return DashboardTask(
      hours: hours,
      minutes: minutes,
      title: title,
      due: due,
      checked: checked ?? this.checked,
    );
  }
}

@immutable
class DashboardState {
  const DashboardState({
    this.selectedIndex = 0,
    this.weeklyHours,
    this.loadingWeekly = false,
    this.weeklyError,
    this.tasks = const [
      DashboardTask(
        hours: 2,
        minutes: 12,
        title: 'Complete Project Proposal',
        due: '2024-03-15',
        checked: true,
      ),
      DashboardTask(
        hours: 1,
        minutes: 45,
        title: 'Refactor Authentication Module',
        due: '2024-03-17',
      ),
    ],
  });

  final int selectedIndex;
  final int? weeklyHours;
  final bool loadingWeekly;
  final String? weeklyError;
  final List<DashboardTask> tasks;

  DashboardState copyWith({
    int? selectedIndex,
    int? weeklyHours,
    bool setWeeklyHoursNull = false,
    bool? loadingWeekly,
    String? weeklyError,
    bool clearWeeklyError = false,
    List<DashboardTask>? tasks,
  }) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      weeklyHours:
          setWeeklyHoursNull ? null : (weeklyHours ?? this.weeklyHours),
      loadingWeekly: loadingWeekly ?? this.loadingWeekly,
      weeklyError: clearWeeklyError ? null : (weeklyError ?? this.weeklyError),
      tasks: tasks ?? this.tasks,
    );
  }
}

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController() : super(const DashboardState());

  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  Future<void> loadWeekly(String userId) async {
    state = state.copyWith(loadingWeekly: true, clearWeeklyError: true);
    try {
      final report = await ApiService.getWeeklyReport(userId);
      state = state.copyWith(
        loadingWeekly: false,
        weeklyHours: (report['totalHours'] as num?)?.toInt(),
      );
    } catch (e) {
      state = state.copyWith(
        loadingWeekly: false,
        setWeeklyHoursNull: true,
        weeklyError: e.toString(),
      );
    }
  }

  void setTaskChecked(int index, bool checked) {
    final nextTasks = [...state.tasks];
    if (index < 0 || index >= nextTasks.length) {
      return;
    }
    nextTasks[index] = nextTasks[index].copyWith(checked: checked);
    state = state.copyWith(tasks: nextTasks);
  }
}

final dashboardProvider =
    StateNotifierProvider.autoDispose<DashboardController, DashboardState>(
  (ref) => DashboardController(),
);

class _TaskCard extends StatelessWidget {
  final int hours;
  final int minutes;
  final String title;
  final String due;
  final Color accent;
  final bool checked;
  final ValueChanged<bool> onCheckedChanged;

  const _TaskCard({
    required this.hours,
    required this.minutes,
    required this.title,
    required this.due,
    required this.accent,
    required this.checked,
    required this.onCheckedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: checked,
            activeColor: accent,
            onChanged: (val) => onCheckedChanged(val ?? false),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                    decoration: checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: accent),
                    const SizedBox(width: 4),
                    Text(
                      '${hours}h ${minutes}m',
                      style: textTheme.bodySmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      due,
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

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final List<DateTime> _dates =
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  final String userId = '1';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).loadWeekly(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final controller = ref.read(dashboardProvider.notifier);

    const accent = Color(0xFFF4C430);
    const accentDark = Color(0xFFD4A017);
    final textTheme = GoogleFonts.interTextTheme();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Dashboard',
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
              const _ProfileCard(accent: accent, accentDark: accentDark),
              const SizedBox(height: 24),
              _DateSelector(
                dates: _dates,
                selected: state.selectedIndex,
                onSelect: controller.setSelectedIndex,
                accent: accent,
              ),
              const SizedBox(height: 24),
              _WeeklySummaryCardGold(
                accent: accent,
                accentDark: accentDark,
                hoursTextOverride: state.loadingWeekly
                    ? '...'
                    : state.weeklyHours != null
                        ? '${state.weeklyHours}h'
                        : '--',
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Tasks',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(state.tasks.length, (index) {
                final task = state.tasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _TaskCard(
                    hours: task.hours,
                    minutes: task.minutes,
                    title: task.title,
                    due: task.due,
                    accent: accent,
                    checked: task.checked,
                    onCheckedChanged: (checked) {
                      controller.setTaskChecked(index, checked);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GoldBottomNav(
        accent: accent,
        items: const [
          GoldNavItem(icon: Icons.home_rounded, label: 'Dashboard'),
          GoldNavItem(icon: Icons.folder_open, label: 'Projects'),
          GoldNavItem(icon: Icons.list_alt_rounded, label: 'My Task'),
          GoldNavItem(icon: Icons.person_rounded, label: 'Profile'),
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
    super.key,
    required this.dates,
    required this.selected,
    required this.onSelect,
    required this.accent,
  });

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
                    '${date.day}/${date.month}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun'
                    ][date.weekday - 1],
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

class _ProfileCard extends StatelessWidget {
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
            color: accentDark.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage:
                AssetImage('assets/images/profile_placeholder.png'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Jane Doe',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back!',
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
    super.key,
    required this.accent,
    required this.accentDark,
    required this.hoursTextOverride,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentDark.withValues(alpha: 0.2), width: 1.5),
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
                  'Weekly Summary',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accentDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total hours logged this week',
                  style: textTheme.bodyMedium?.copyWith(
                    color: accentDark.withValues(alpha: 0.7),
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
