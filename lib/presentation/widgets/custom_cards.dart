import 'package:flutter/material.dart';

import '../views/class_attendance/student_listing/student_list.dart';

class DynamicGridViewWidget extends StatelessWidget {
  // Example data
  List<Map<String, dynamic>> cardData = [];
  DynamicGridViewWidget(this.cardData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Prevents inner scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Three cards per row
          crossAxisSpacing: 16, // Spacing between columns
          mainAxisSpacing: 16, // Spacing between rows
          childAspectRatio: 80 / 77, // Card width-to-height ratio
        ),
        itemCount: cardData.length,
        itemBuilder: (context, index) {
          List<bool> isToggled = List.filled(cardData.length, false);
          final data = cardData[index];
          return StatefulBuilder(
            builder: (context, setState) {
              // To track card color state
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    isToggled[index] = !isToggled[index];
                  });
                  await Future.delayed(const Duration(milliseconds: 80));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentListScreen(
                        title: data['title'],
                        count: data['count'],
                        label: data['label'],
                        classId: data['classId'],
                      ),
                    ),
                  );

                  setState(() {
                    isToggled[index] = !isToggled[index];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isToggled[index]
                        ? Color(0xFF33CC99)
                        : const Color(0xFFED7902),
                    border:
                        Border.all(color: const Color(0xFFE2E2E2), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cardData[index]['title'],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40, // Line width
                        height: 1, // Line height
                        color: Colors.white, // Line color
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      Text(
                        '${cardData[index]['count']}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cardData[index]['label'],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Color(0xFFE2E2E2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
