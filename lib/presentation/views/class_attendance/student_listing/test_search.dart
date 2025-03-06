import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/repo/auth_repo.dart';
import '../../../../data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import '../../../responsiveness/screen_utils.dart';

class TestSearchScreen extends StatelessWidget {
  const TestSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          title: Row(
            children: [
              SizedBox(
                width: ScreenUtil.getSize(90),
              ),
              Align(
                alignment: Alignment.center,
                // This ensures the title is centered
                child: Text(
                  "ezskool",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil.getResponsiveFont(20)),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFED7902),
          elevation: ScreenUtil.getSize(0),
        ),
        drawer: buildDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchAnchor.bar(
            barHintText: 'Search here',
            suggestionsBuilder: (context, controller) {
              return List<ListTile>.generate(5, (index) {
                return ListTile(
                  title: Text('Item $index'),
                  onTap: () {},
                );
              });
            },
          ),
        ),
      ),
    );
  }
}

Widget buildDrawer(BuildContext context) {
  ScreenUtil().init(context);
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFFED7902),
          ),
          child: Text(
            'Welcome!',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.getResponsiveFont(24),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pushNamed(context, '/nclsatthome');
            // Implement the logout functionality here
            // For example: AuthRepository().logout(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: const Text('Students'),
          onTap: () {
            Navigator.pushNamed(context, '/stlst');
          },
        ),

        ListTile(
          leading: const Icon(Icons.cake),
          title: const Text('Birthdays'),
          onTap: () {
            Navigator.pushNamed(context, '/birthdays');
          },
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('test search'),
          onTap: () {
            Navigator.pushNamed(context, '/test');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            // Implement the logout functionality here
            // For example:
            // Navigator.pushReplacementNamed(context, '/login');
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFED7902)),
                    strokeWidth: ScreenUtil.getSize(5),
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                );
              },
            );
            final clvm = Provider.of<ClassAttendanceHomeViewModel>(context,
                listen: false);
            clvm.resetSelections();
            AuthRepository().logout(context);
          },
        ),
        // You can add more Drawer options here
      ],
    ),
  );
}
