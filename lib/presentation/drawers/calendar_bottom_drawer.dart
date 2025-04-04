import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CalendarBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final String hintText;
  final DateTime? minimumDate;

  const CalendarBottomSheet({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.hintText = '',
    this.minimumDate,
  });

  @override
  _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime selectedDate;
  late DateTime _adjustedDate;

  @override
  void initState() {
    super.initState();
    //selectedDate = widget.initialDate;

    if (widget.minimumDate != null &&
        widget.initialDate.isBefore(widget.minimumDate!)) {
      selectedDate = widget.minimumDate!;
    } else {
      selectedDate = widget.initialDate;
    }

    final today = DateTime.now();
    if (selectedDate.isAfter(today)) {
      selectedDate = today;
    }

    _adjustedDate = selectedDate;
  }

  void _changeMonth(int offset) {
    setState(() {
      // Move to the new month
      final newMonth = DateTime(
          _adjustedDate.year, _adjustedDate.month + offset, _adjustedDate.day);

      // Update the displayed month
      _adjustedDate = newMonth;

      // Adjust the selected date if it would be invalid in the new month
      _updateSelectedDateIfInvalid();
    });
  }

  bool _isDateSelectable(DateTime date) {
    final today = DateTime.now();

    // Future dates are not selectable
    if (date.isAfter(today)) {
      return false;
    }

    // Dates before minimum date are not selectable
    if (widget.minimumDate != null && date.isBefore(widget.minimumDate!)) {
      return false;
    }

    return true;
  }

  void _updateSelectedDateIfInvalid() {
    final lastDayOfMonth =
        DateTime(_adjustedDate.year, _adjustedDate.month + 1, 0);

    // Create a potential new selected date in the current month view
    DateTime potentialSelectedDate = DateTime(
      _adjustedDate.year,
      _adjustedDate.month,
      selectedDate.day > lastDayOfMonth.day
          ? lastDayOfMonth.day
          : selectedDate.day,
    );

    // Check if it's a valid date (selectable)
    bool isValid = _isDateSelectable(potentialSelectedDate);

    if (isValid) {
      // If valid, update selected date
      selectedDate = potentialSelectedDate;
    } else {
      // If not valid, find a suitable date in this month

      // Try to find a valid date in the current month
      bool foundValidDate = false;

      // Start from the last day of month and go backward
      // This gives preference to the most recent valid date
      for (int day = lastDayOfMonth.day; day >= 1; day--) {
        final candidateDate =
            DateTime(_adjustedDate.year, _adjustedDate.month, day);
        if (_isDateSelectable(candidateDate)) {
          selectedDate = candidateDate;
          foundValidDate = true;
          break;
        }
      }

      // If no valid date found in this month, don't change the selection
      // But ensure it's not visually highlighted in the current month view
      if (!foundValidDate) {
        // Keep selectedDate unchanged, but it won't show as selected
        // in the current month view because its month differs
      }
    }
  }

  // void _changeMonth(int offset) {
  //   setState(() {
  //     selectedDate = DateTime(
  //         selectedDate.year, selectedDate.month + offset, selectedDate.day);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final currentMonth = DateFormat('MMMM yyyy').format(selectedDate);
    // final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    // final lastDayOfMonth =
    //     DateTime(selectedDate.year, selectedDate.month + 1, 0);

    final currentMonth = DateFormat('MMMM yyyy').format(_adjustedDate);
    final firstDayOfMonth =
        DateTime(_adjustedDate.year, _adjustedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_adjustedDate.year, _adjustedDate.month + 1, 0);
    final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final totalDays = firstWeekdayOfMonth + lastDayOfMonth.day;
    final totalWeeks = ((totalDays + 6) ~/ 7);
    final today = DateTime.now();

    final selectedIsInCurrentMonth = selectedDate.year == _adjustedDate.year &&
        selectedDate.month == _adjustedDate.month;

    return Container(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4.h,
            width: 164.w,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(22.r),
            ),
          ),

          if (widget.hintText.isNotEmpty) ...[
            SizedBox(height: 15.h),
            Text(
              widget.hintText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                color: Color(0xFF494949),
              ),
            ),
          ],

          SizedBox(height: 20.h),
          // Month navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: Colors.black),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                currentMonth,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.black),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Days of the week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              // Convert weekday to match the days list index (Sunday = 0)
              // final currentWeekday = selectedDate.weekday % 7;
              // final isSelectedDay = days.indexOf(day) == currentWeekday;

              final dayIndex = days.indexOf(day);

              final isSelectedDay = dayIndex == selectedDate.weekday % 7 &&
                  selectedIsInCurrentMonth &&
                  _isDateSelectable(selectedDate);

              return Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelectedDay ? Color(0xFFED7902) : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelectedDay ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
          // Calendar grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(totalWeeks * 7, (index) {
              final dayOffset = index - firstWeekdayOfMonth;
              if (dayOffset < 0 || dayOffset >= lastDayOfMonth.day) {
                return Container(); // Empty space
              }

              // final date = DateTime(
              //     selectedDate.year, selectedDate.month, dayOffset + 1);
              // final isSelected = selectedDate.year == date.year &&
              //     selectedDate.month == date.month &&
              //     selectedDate.day == date.day;

              //final isFutureDate = date.isAfter(today);

              final date = DateTime(
                  _adjustedDate.year, _adjustedDate.month, dayOffset + 1);

              final isSelectable = _isDateSelectable(date);

              final isSelected = selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day;

              // Only show selection highlight if the date is selectable and selected
              final showSelectionHighlight = isSelected && isSelectable;

              return InkWell(
                onTap: isSelectable
                    ? () {
                        setState(() {
                          selectedDate = date;
                        });
                        widget.onDateSelected(selectedDate);
                        Navigator.pop(context); // Close the bottom sheet
                      }
                    : null,

                // isFutureDate ||
                //         (widget.minimumDate != null &&
                //             date.isBefore(widget.minimumDate!))
                //     ? null
                //     : () {
                //         setState(() {
                //           selectedDate = date;
                //         });
                //         widget.onDateSelected(selectedDate);
                //         Navigator.pop(context); // Close the bottom sheet
                //       },
                child: Container(
                  decoration: BoxDecoration(
                    // color: showSelectionHighlight
                    //     ? Color(0xFFED7902)
                    //     : (isFutureDate ||
                    //             (widget.minimumDate != null &&
                    //                 date.isBefore(widget.minimumDate!))
                    //         ? Colors.grey.shade200
                    //         : Colors.white),
                    color: showSelectionHighlight
                        ? Color(0xFFED7902)
                        : (isSelectable ? Colors.white : Colors.grey.shade200),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${dayOffset + 1}",
                    style: TextStyle(
                      color: showSelectionHighlight
                          ? Colors.white
                          : (isSelectable ? Colors.black : Colors.grey),
                      fontWeight: showSelectionHighlight
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    // style: TextStyle(
                    //   color: isSelected ||
                    //           (widget.minimumDate != null &&
                    //               date.isBefore(widget.minimumDate!))
                    //       ? Colors.white
                    //       : (isFutureDate ? Colors.grey : Colors.black),
                    //   fontWeight:
                    //       isSelected ? FontWeight.bold : FontWeight.normal,
                    // ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
