import 'package:flutter/material.dart';

/// Shows a date of birth picker styled like the provided UI.
Future<DateTime?> showDobRangeSheet(
  BuildContext context, {
  DateTime? initialDate,
}) async {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
          // Ensure the selected date is within 2025-2026
      DateTime? selectedDate = initialDate != null && 
          initialDate.year >= 2025 && 
          initialDate.year <= 2026 
              ? initialDate 
              : DateTime(2025);
              
      // Set current month to the selected date or default to January 2025
      DateTime currentMonth = DateTime(
        selectedDate.year,
        selectedDate.month,
        1,
      );
      
      // Ensure current month is within 2025-2026
      if (currentMonth.year < 2025) {
        currentMonth = DateTime(2025, 1, 1);
      } else if (currentMonth.year > 2026) {
        currentMonth = DateTime(2026, 12, 1);
      }

      List<DateTime?> _buildDays(DateTime month) {
        final first = DateTime(month.year, month.month, 1);
        final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
        final offset = first.weekday % 7; // Sunday first column
        final result = List<DateTime?>.filled(42, null);

        for (int i = 0; i < daysInMonth; i++) {
          result[offset + i] = DateTime(month.year, month.month, i + 1);
        }
        return result;
      }

      void handleTap(DateTime day, void Function(void Function()) setState) {
        setState(() {
          selectedDate = day;
        });
      }

      bool isSelected(DateTime day) {
        if (selectedDate == null) return false;
        return day.year == selectedDate!.year &&
               day.month == selectedDate!.month &&
               day.day == selectedDate!.day;
      }

      bool isToday(DateTime day) {
        final now = DateTime.now();
        return day.year == now.year &&
               day.month == now.month &&
               day.day == now.day;
      }

      String _getMonthName(int month) {
        return [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ][month - 1];
      }

      return StatefulBuilder(
        builder: (context, setState) {
          final days = _buildDays(currentMonth);

          return Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2E2A52),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient background
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00D4FF), Color(0xFF0066FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Select DOB',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Month and Year navigation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Column(
                    children: [
                      // Year selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: currentMonth.year > 2025 ? () {
                              setState(() {
                                currentMonth = DateTime(currentMonth.year - 1, currentMonth.month, 1);
                              });
                            } : null,
                            icon: Icon(
                              Icons.chevron_left,
                              color: currentMonth.year > 2025 ? Colors.white : Colors.grey,
                              size: 24,
                            ),
                          ),
                          Text(
                            '${currentMonth.year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: currentMonth.year < 2026 ? () {
                              setState(() {
                                currentMonth = DateTime(currentMonth.year + 1, currentMonth.month, 1);
                              });
                            } : null,
                            icon: Icon(
                              Icons.chevron_right,
                              color: currentMonth.year < 2026 ? Colors.white : Colors.grey,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Month navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
                              });
                            },
                            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                          ),
                          Text(
                            _getMonthName(currentMonth.month),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
                              });
                            },
                            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Weekday headers
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _WeekdayLabel('S'),
                      _WeekdayLabel('M'),
                      _WeekdayLabel('T'),
                      _WeekdayLabel('W'),
                      _WeekdayLabel('T'),
                      _WeekdayLabel('F'),
                      _WeekdayLabel('S'),
                    ],
                  ),
                ),

                // Calendar grid
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      if (day == null) return const SizedBox.shrink();

                      final selected = isSelected(day);
                      final today = isToday(day);

                      return GestureDetector(
                        onTap: () => handleTap(day, setState),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFFF6B47)
                                : today
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                            border: today && !selected
                                ? Border.all(color: const Color(0xFF00D4FF), width: 1.5)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : today
                                        ? const Color(0xFF00D4FF)
                                        : Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: selected || today
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Submit button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: ElevatedButton(
                    onPressed: selectedDate != null
                        ? () {
                            Navigator.of(context).pop(selectedDate);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B47),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                      shadowColor: const Color(0xFFFF6B47).withOpacity(0.4),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

