import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/home_repo.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/main.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final stRepo = StudentRepository();
  final homeRepo = HomeRepo();

  @override
  void initState() {
    super.initState();

    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    // setState(() {
    //   isLoading = true;
    // });
    // final prefs = await SharedPreferences.getInstance();
    // bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    // if (isFirstLaunch) {
    //   await loadLD();
    //   await stRepo.fetchAllClasses(); // Fetch fresh data only on first launch
    //   await prefs.setBool('isFirstLaunch', false);
    // }

    // await loadClasses(); // Always load classes to update UI
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        await loadLD();
        await stRepo.fetchAllClasses();
        await prefs.setBool('isFirstLaunch', false);
      }

      await loadClasses(); // This sets isLoading to false when successful
    } catch (e) {
      // Handle any errors
      Log.d('Error in checkFirstLaunch: $e');

      // Make sure to set isLoading to false even if there's an error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstLaunch', true); // Reset on app close
    }
  }

  Future<void> loadClasses() async {
    // final cls = await stRepo.getAllClasses();
    // Log.d(cardData);

    // setState(() {
    //   cardData = cls;
    //   Log.d(cardData);
    //   isLoading = false;
    //   Log.d(isLoading);
    // });
    try {
      final cls = await stRepo.getAllClasses();

      Log.d(cls);

      setState(() {
        isLoading = false;
        Log.d(isLoading);
      });
    } catch (e) {
      Log.d('Error loading classes: $e');

      setState(() {
        isLoading = false; // Ensure isLoading is set to false even on error
      });
    }
  }

  Future<void> loadLD() async {
    // await homeRepo.loginSyncLrDiv();
    // divisions = await HomeRepo.dropdownDao.getDropdownValues('div');

    // Provider.of<ClassAttendanceHomeViewModel>(
    //         navigatorKey.currentState!.context,
    //         listen: false)
    //     .setDivisions(divisions);

    //isLoading = false;
    try {
      await homeRepo.loginSyncLrDiv();

      // setState not needed here as loadClasses will handle it
    } catch (e) {
      Log.d('Error in loadLD: $e');
      // No need to set isLoading = false here, as it will be handled in the calling function
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xFFED7902),
            ))
          : Center(child: Text('Home Screen to be released soon')),
    );
  }
}
