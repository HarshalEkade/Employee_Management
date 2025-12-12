import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_controller.dart';
import 'add_edit_employee_page.dart';
import '../models/employee.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/date_range_sheet.dart';
import '../widgets/employee_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  int current = 0;

  Alignment _indicatorAlignment(int index) {
    switch (index) {
      case 0:
        return Alignment.centerLeft;
      case 1:
        return const Alignment(-0.33, 0);
      case 2:
        return const Alignment(0.33, 0);
      case 3:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller = Get.find<EmployeeController>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !controller.isLoading.value &&
        controller.hasMore.value) {
      controller.loadEmployees();
    }
  }

  Future<void> _openRangePicker(EmployeeController controller) async {
    final selectedDate = await showDobRangeSheet(
      context,
      initialDate: controller.dobRange.value?.start,
    );
    if (selectedDate != null) {
      await controller.applyDobRange(
        DateTimeRange(start: selectedDate, end: selectedDate),
      );
    } else {
      await controller.applyDobRange(null);
    }
  }

  void _openForm([Employee? employee]) {
    Get.to(() => AddEditEmployeePage(employee: employee));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D26),
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(34),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2FC5FF), Color(0xFF4668FF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Sandy Chungus',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.clearFilters(),
                        icon: const Icon(Icons.notifications_outlined,
                            color: Colors.white70, size: 24),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert, color: Colors.white70, size: 24),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF12163A), Color(0xFF0D1231)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1D214B), Color(0xFF0F1333)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: Colors.white.withOpacity(0.08)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: controller.updateSearch,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    decoration: const InputDecoration(
                                      hintText: 'Search...',
                                      hintStyle:
                                          TextStyle(color: Colors.white60, fontSize: 14),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => _openRangePicker(controller),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.9), width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _ActionIcon(
                                  iconPath: 'assets/icons/Add.png',
                                  onTap: _openForm,
                                ),
                                _ActionIcon(
                                  iconPath: 'assets/icons/filter.png',
                                  onTap: () => _openRangePicker(controller),
                                ),
                                _ActionIcon(
                                  iconPath: 'assets/icons/Clock.png',
                                  onTap: () async {
                                    if (controller.employees.isNotEmpty) {
                                      final emp = controller.employees.first;
                                      final confirmed =
                                          await showConfirmDeleteDialog(context);
                                      if (confirmed) {
                                        await controller.deleteEmployee(emp.id!);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Obx(
                              () => RefreshIndicator(
                                onRefresh: () => controller.loadEmployees(reset: true),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(
                                    left: 2,
                                    right: 2,
                                    top: 10,
                                    bottom: 12,
                                  ),
                                  itemCount: controller.employees.length +
                                      (controller.hasMore.value ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index >= controller.employees.length) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    final employee = controller.employees[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: EmployeeCard(
                                        employee: employee,
                                        onEdit: () => _openForm(employee),
                                        onDelete: () async {
                                          final confirmed =
                                              await showConfirmDeleteDialog(context);
                                          if (confirmed) {
                                            await controller.deleteEmployee(employee.id!);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 14),
              child: NeonExactNavbar(
                selectedIndex: current,
                onTap: (i) => setState(() => current = i),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.iconPath,
    required this.onTap,
    this.icon,
  });

  final String iconPath;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0x141C2554),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: iconPath.isNotEmpty
              ? Image.asset(iconPath, width: 44, height: 44)
              : Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class ExactWavePainter extends CustomPainter {
  final Color baseColor;
  const ExactWavePainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;

    final path = Path();
    path.moveTo(0, h * 0.35);
    path.quadraticBezierTo(w * 0.08, h * 0.05, w * 0.22, h * 0.03);
    path.quadraticBezierTo(w * 0.38, 0, w * 0.46, h * 0.18);
    path.cubicTo(w * 0.55, h * 0.36, w * 0.72, h * 0.02, w * 0.88, h * 0.02);
    path.quadraticBezierTo(w * 0.96, h * 0.03, w, h * 0.35);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.55), 24.0, true);

    final rect = Rect.fromLTWH(0, 0, w, h);
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.0, 0.35, 0.72, 1.0],
      colors: [
        const Color(0xFF0FD6FF).withOpacity(0.10),
        const Color(0xFF0B1A3A).withOpacity(0.95),
        const Color(0xFF6E4DAA).withOpacity(0.22),
        const Color(0xFF0A0D23).withOpacity(0.98),
      ],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawPath(path, paint);

    final strokePath = Path();
    strokePath.moveTo(6, h * 0.22);
    strokePath.quadraticBezierTo(w * 0.08 + 6, h * 0.06, w * 0.22, h * 0.04);
    strokePath.quadraticBezierTo(w * 0.40, -6, w * 0.46 + 6, h * 0.16);
    strokePath.quadraticBezierTo(w * 0.66, h * 0.34, w * 0.88 - 6, h * 0.04);
    strokePath.lineTo(w - 6, h * 0.22);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.12),
          Colors.white.withOpacity(0.04),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(strokePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeonExactNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const NeonExactNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 110;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: const ExactWavePainter(baseColor: Color(0xFF0A0D23)),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withOpacity(0.02),
                        Colors.white.withOpacity(0.01),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (i) => _buildIcon(context, i)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 120,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, int i) {
    final bool active = i == selectedIndex;
    final double pad = active ? 14 : 12;
    final double iconSize = active ? 26 : 26;

    final glow = Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active
            ? RadialGradient(
                center: const Alignment(-0.6, -0.2),
                radius: 0.9,
                colors: [
                  const Color(0xFF2DE6FF).withOpacity(0.34),
                  const Color(0xFF2DE6FF).withOpacity(0.07),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.25, 1.0],
              )
            : null,
      ),
    );

    final Color iconColor =
        active ? const Color(0xFF2DE6FF) : Colors.white.withOpacity(0.5);

    IconData iconData;
    switch (i) {
      case 0:
        iconData = Icons.home_rounded;
        break;
      case 1:
        iconData = Icons.credit_card_rounded;
        break;
      case 2:
        iconData = Icons.person_rounded;
        break;
      default:
        iconData = Icons.bar_chart_rounded;
    }

    return GestureDetector(
      onTap: () => onTap(i),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (active) glow,
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: 54,
              height: 54,
              padding: EdgeInsets.all(pad),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? Colors.white.withOpacity(0.02) : Colors.transparent,
              ),
              child: Icon(
                iconData,
                size: iconSize,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
