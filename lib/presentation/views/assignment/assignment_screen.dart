import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';

import '../../dialogs/custom_dialog.dart';
import 'new_assignment_screen.dart';
import 'task_details.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Assignment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewAssignmentScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED7902),
                minimumSize: const Size(double.infinity, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: const Text(
                '+ Create New Assignment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filters',
                style: TextStyle(
                  color: Color(0xFF626262),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.01,
                ),
              ),
            ),
            const SizedBox(height: 3),

            Row(
              children: [
                // Class Button
                SizedBox(
                  width: 125,
                  height: 31,
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle class filter
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      side: const BorderSide(
                          color: Color(0xFF969AB8), width: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Class',
                          style: TextStyle(
                            color: Color(0xFF969AB8),
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down,
                            color: Color(0xFF969AB8), size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Date Button
                Expanded(
                  child: SizedBox(
                    height: 31,
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle date filter
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        side: const BorderSide(
                            color: Color(0xFF969AB8), width: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Date',
                            style: TextStyle(
                              color: Color(0xFF969AB8),
                              fontSize: 14,
                            ),
                          ),
                          Icon(Icons.calendar_today,
                              color: Color(0xFFB8BCCA), size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // Assignment Cards List
            Expanded(
              child: ListView(
                children: const [
                  AssignmentCard(
                    subject: 'Mathematics',
                    className: '6 A',
                    teacherName: 'Mrs. Priya Ahuja',
                    assignDate: '21-02-2025',
                    deadline: '26-02-2025',
                  ),
                  SizedBox(height: 12),
                  AssignmentCard(
                    subject: 'Science',
                    className: '8 B',
                    teacherName: 'Mr. Shrikant Sharma',
                    assignDate: '21-02-2025',
                    deadline: '26-02-2025',
                  ),
                  SizedBox(height: 12),
                  AssignmentCard(
                    subject: 'English',
                    className: '8 A',
                    teacherName: 'Mrs. Kavita Shah',
                    assignDate: '21-02-2025',
                    deadline: '26-02-2025',
                  ),
                  SizedBox(height: 12),
                  AssignmentCard(
                    subject: 'Language II',
                    className: '5 A',
                    teacherName: 'Mr. Manish Kumar',
                    assignDate: '21-02-2025',
                    deadline: '26-02-2025',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final String subject;
  final String className;
  final String teacherName;
  final String assignDate;
  final String deadline;

  const AssignmentCard({
    super.key,
    required this.subject,
    required this.className,
    required this.teacherName,
    required this.assignDate,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        //clipBehavior: Clip.antiAlias, // Ensures all corners are rounded
        child: Container(
          width: 351,
          height: 108,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF969AB8), width: 0.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          // height: 101,
          child: Column(
            children: [
              // Upper section
              Container(
                height: 64,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF626262),
                  //border: Border.all(color: const Color(0xFF969AB8), width: 0.5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subject,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Assign Date : $assignDate',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          className,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Deadline: $deadline',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Lower section
              Container(
                height: 43,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAECEC),
                  //border: Border.all(color: const Color(0xFF969AB8), width: 0.5),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // const CircleAvatar(
                    //   radius: 10,
                    //   backgroundColor: Colors.grey,
                    // ),
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      teacherName,
                      style: const TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskDetailsScreen()),
                        );
                      },
                      child: const Icon(Icons.remove_red_eye,
                          color: Colors.blue, size: 20),
                    ),

                    const SizedBox(width: 10),
                    const Icon(Icons.edit, color: Color(0xFF626262), size: 20),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: 'Delete Assignment?',
                              height: 250,
                              buttonText: 'Yes',
                              showCloseButton: false,
                              hasCancelButton: true,
                              cancelButtonText: 'Cancel',
                              icon: Icons.delete,
                              iconColor: Colors.red, // Red color for error
                              backgroundColor:
                                  Color(0xFFED7902), // Red background
                              onButtonPressed: () {
                                // Custom action for retry
                                Navigator.pop(context); // Close the dialog
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.delete,
                          color: Color(0xFFDD3E2B), size: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
