import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClassAttendanceHomeScreen extends StatefulWidget {
  const ClassAttendanceHomeScreen({super.key});

  @override
  _ClassAttendanceHomeScreenState createState() =>
      _ClassAttendanceHomeScreenState();
}

enum ViewState { calendar, qrScanner, manualAttendance }

class _ClassAttendanceHomeScreenState extends State<ClassAttendanceHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _selectedDate = DateTime.now();
  ViewState _currentView = ViewState.calendar;

  String? selectedStandard;
  String? selectedDivision;
  bool isDropdownOpen = false;

  // Sample list for dropdown boxes
  List<String> standards = List.generate(10, (index) => '${index + 1}');
  List<String> divisions = ['A', 'B', 'C', 'D'];

  // final List<String> _days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  @override
  void initState()  {
    super.initState();

  }


  void _changeMonth(int direction) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + direction,
      );
    });
  }

  void _changeYear() {
    // Add year selection functionality if needed
  }

  void _changeView(ViewState view) {
    setState(() {
      _currentView = view;
    });
  }

  void _onQRScanned(String code) {
    print("QR Code: $code");
    // Return to calendar after QR scanning
    Future.delayed(Duration(seconds: 1), () {
      _changeView(ViewState.calendar);
    });
  }

  Widget _buildDropdownField(
      String hintText, String? selectedValue, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.only(left: 92),
        height: 45,
        width: 306,
        decoration: BoxDecoration(
          color: Color(0xFFED7902),
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(color: Color(0xFF9D9D9D)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 18.1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValue ?? hintText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                isDropdownOpen ? Icons.arrow_right : Icons.arrow_downward,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDropdown(String field) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: field == 'Select Standard' ? 327 : 182,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 13),
                Container(
                  height: 4,
                  width: 162,
                  decoration: BoxDecoration(
                    color: Color(0xFFED7902), //0xFFD9D9D9
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  field == 'Select Standard'
                      ? 'Select Standard'
                      : 'Select Division',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    height: 1.5,
                    color: Color(0xFF181818), //0xFF181818
                  ),
                ),
                SizedBox(height: 30),

                // Dropdown options (GridView for Select Standard / Select Division)
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 42),
                    shrinkWrap: true,
                    itemCount: field == 'Select Standard'
                        ? standards.length
                        : divisions.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: field == 'Select Standard'
                          ? 4
                          : 4, // 5 for Standard, 3 for Division
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (field == 'Select Standard') {
                              selectedStandard = standards[index];
                            } else {
                              selectedDivision = divisions[index];
                            }
                          });
                          Navigator.pop(context); // Close the dropdown
                        },
                        child: Container(
                          height: 51,
                          width: 58,
                          decoration: BoxDecoration(
                            color: Color(0xFFED7902), //0xFFED7902
                            border: Border.all(color: Color(0xFFE2E2E2)),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              field == 'Select Standard'
                                  ? standards[index]
                                  : divisions[index], // Divisions A, B, C
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                height: 1.5,
                                color: Color(0xFFFAECEC),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ), // Menu icon aligned to the left

        title: Row(
          children: [
            const SizedBox(
              width: 90,
            ),
            Align(
              alignment: Alignment.center,
              // This ensures the title is centered
              child: Text(
                "ezskool",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),

        backgroundColor: Color(0xFFED7902),
        elevation: 0,
        // flexibleSpace: Center(  // This centers the title within the AppBar
        //   child: Text(
        //     "EzSkool",
        //     style: TextStyle(color: Colors.white, fontSize: 20),
        //   ),
        // ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFED7902), // Header color
              ),
              child: Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                //logout(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Attendance",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF494949),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 84,
              height: 21,
              child: Text(
                  'Select Date', // Replace with your desired text
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.5, // Line height equivalent to 150%
                    letterSpacing: 0.01,
                    color: Color(0xFFA19595),
                  )),
            ),
            SizedBox(height: 10),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: _currentView == ViewState.calendar
                  ? _buildCalendar()
                  : _currentView == ViewState.qrScanner
                      ? _buildQRScanner()
                      : _buildManualAttendance(),
            ),
            // SizedBox(height: 24),

            SizedBox(height: 32),
            _buildDropdownField('Select Standard', selectedStandard, () {
              setState(() {
                isDropdownOpen = !isDropdownOpen;
              });
              _openDropdown('Select Standard');
            }),
            SizedBox(height: 24),

            // Select Division Dropdown
            _buildDropdownField('Select Division', selectedDivision, () {
              setState(() {
                isDropdownOpen = !isDropdownOpen;
              });
              _openDropdown('Select Division');
            }),
            const SizedBox(height: 32),

            // Text(
            //   "Select Attendance Mode",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xFF494949),
            //   ),
            // ),
            // SizedBox(height: 16),
            _buildAttendanceMode(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final currentMonth = DateFormat('MMMM yyyy').format(_selectedDate);

    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    final daysInMonth = List<DateTime>.generate(
      lastDayOfMonth.day,
      (i) => DateTime(_selectedDate.year, _selectedDate.month, i + 1),
    );

    final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    // Adjust weekday to align with the custom day list
    final firstWeekdayOfMonth = (firstDayOfMonth.weekday %
        7); // Adjust for Sunday = 0, Monday = 1, ..., Saturday = 6

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row for Month and Year with navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.black),
                  onPressed: () => _changeMonth(-1),
                ),
                InkWell(
                  onTap: _changeYear,
                  child: Text(
                    currentMonth, // Show month name and year
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.black),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Row for Weekdays (Sun, Mon, Tue, etc.)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((day) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedDate.weekday == days.indexOf(day)
                          ? Color(0xFFED7902) // Highlight selected day
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedDate.weekday == days.indexOf(day)
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),

            // Grid of Dates (using the first weekday offset)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(firstWeekdayOfMonth, (index) {
                // Empty containers before the start of the month (for alignment)
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.transparent,
                );
              })
                ..addAll(daysInMonth.map((date) {
                  final isSelected = _selectedDate.day == date.day &&
                      _selectedDate.month == date.month &&
                      _selectedDate.year == date.year;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFFED7902) : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${date.day}",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRScanner() {
    return SizedBox(
      width: 284,
      height: 305,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // child: Center(child: Text('Mobile Scanner not available for IOS')),
        child: MobileScanner(
          onDetect: (barcodeCapture) {
            final List<Barcode> barcodes = barcodeCapture.barcodes;
            final String code =
                barcodes.isNotEmpty ? barcodes.first.rawValue ?? '---' : '---';

            _onQRScanned(code);
          },
        ),
      ),
    );
  }

  Widget _buildManualAttendance() {
    void openDropdown(String field) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              height: field == 'Select Standard' ? 327 : 182,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 13),
                  Container(
                    height: 4,
                    width: 162,
                    decoration: BoxDecoration(
                      color: Color(0xFFED7902), //0xFFD9D9D9
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    field == 'Select Standard'
                        ? 'Select Standard'
                        : 'Select Division',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      height: 1.5,
                      color: Color(0xFF181818), //0xFF181818
                    ),
                  ),
                  SizedBox(height: 30),

                  // Dropdown options (GridView for Select Standard / Select Division)
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 42),
                      shrinkWrap: true,
                      itemCount: field == 'Select Standard'
                          ? standards.length
                          : divisions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: field == 'Select Standard'
                            ? 4
                            : 4, // 5 for Standard, 3 for Division
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (field == 'Select Standard') {
                                selectedStandard = standards[index];
                              } else {
                                selectedDivision = divisions[index];
                              }
                            });
                            Navigator.pop(context); // Close the dropdown
                          },
                          child: Container(
                            height: 51,
                            width: 58,
                            decoration: BoxDecoration(
                              color: Color(0xFFED7902), //0xFFED7902
                              border: Border.all(color: Color(0xFFE2E2E2)),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                field == 'Select Standard'
                                    ? standards[index]
                                    : divisions[index], // Divisions A, B, C
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  height: 1.5,
                                  color: Color(0xFFFAECEC),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // Dropdown field builder with dynamic arrow
    Widget buildDropdownField(
        String hintText, String? selectedValue, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 12),
          padding: EdgeInsets.only(left: 92),
          height: 45,
          width: 306,
          decoration: BoxDecoration(
            color: Color(0xFFED7902),
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Color(0xFF9D9D9D)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 18.1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedValue ?? hintText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  isDropdownOpen ? Icons.arrow_right : Icons.arrow_downward,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Text Field Builder
    Widget buildTextField(String hintText) {
      return Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF9D9D9D)),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hintText,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF9D9D9D),
            ),
          ),
        ),
      );
    }

    // Button Builder
    Widget buildButton(String label, Color bgColor, Color textColor) {
      return Container(
        height: 41,
        width: label == 'OK' ? 79 : 115,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: textColor,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: 338,
        height: 350,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFED7902), Color(0xFF874501)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: Color(0xFFC4C4C4), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Select Standard Dropdown
              SizedBox(height: 8),
              buildDropdownField('Select Standard', selectedStandard, () {
                setState(() {
                  isDropdownOpen = !isDropdownOpen;
                });
                openDropdown('Select Standard');
              }),
              SizedBox(height: 24),

              // Select Division Dropdown
              buildDropdownField('Select Division', selectedDivision, () {
                setState(() {
                  isDropdownOpen = !isDropdownOpen;
                });
                openDropdown('Select Division');
              }),
              const SizedBox(height: 24),

              // Enter Roll Number TextField
              buildTextField('Enter Roll Number'),
              const SizedBox(height: 34),

              // Cancel and OK Buttons
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  buildButton('Cancel', const Color(0xFFF5F5F5),
                      const Color(0xFF626262)),
                  const SizedBox(
                    width: 30,
                  ),
                  buildButton(
                      'OK', const Color(0xFFFFFFFF), const Color(0xFFED7902)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildModeCard(
          color: Colors.white,//Color(0xFFFFF3E5), //0xFFFFE8D1
          svgPath: 'assets/class.svg',
          label: "Manual Attendance",
          textColor: Colors.black,//Color(0xFFED7902),
          onTap: () async {
            // showStudentNotFoundErrorDialog(context);
            // showAttendanceDialog(context);
            // try {
            //   List<Map<String, String>> students = await fetchStudentData();
            //   for (var student in students) {
            //     print(student);  // Prints each student as a map
            //   }
            // } catch (e) {
            //   print(e);
            // }
            // _changeView(ViewState.qrScanner);
          },
        ),
        _buildModeCard(
            color: Color(0xFFFFE8D1),//Colors.white,
            svgPath: 'assets/appoint.svg',
            label: "Confirm Attendance",
            textColor: Color(0xFFED7902),
            onTap: () {
              _changeView(ViewState.manualAttendance);
              // showAttendanceDialog(context);
            }),
      ],
    );
  }

  Widget _buildModeCard({
    Color? color,
    String? svgPath,
    String? label,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 140,
          height: 140,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgPath!,
                width: 58,
                height: 58,
                // color: textColor,
              ),
              SizedBox(height: 8),
              Text(
                label!,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
