import 'package:ezskool/core/bloc/auth_bloc.dart';
import 'package:ezskool/core/constants/api.dart';
import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_viewmodel.dart';
import 'package:ezskool/data/viewmodels/class_confirm_attendance_viewmodel.dart';
import 'package:ezskool/data/viewmodels/home_viewmodel.dart';
import 'package:ezskool/data/viewmodels/login_viewmodel.dart';
import 'package:ezskool/data/viewmodels/registration_viewmodel.dart';
import 'package:ezskool/presentation/views/class_attendance/new_class_attendance_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:ezskool/presentation/screens/splashscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/local/db/app_database.dart';
import 'data/viewmodels/class_attendance/student_listing_viewmodel.dart';

import 'package:permission_handler/permission_handler.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  final status = await Permission.notification.status;
  Log.d("Notification permission status: $status");

  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'attendance_channel', // Unique ID
    'Attendance Notifications', // Channel Name
    description: 'Notifications for attendance marking', // Channel Description
    importance: Importance.high, // High Importance (Will pop up)
  );

  // Register the channel
  final AndroidFlutterLocalNotificationsPlugin? androidPlatform =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidPlatform?.createNotificationChannel(channel);
}

void main() async {
  // await setToken();
  WidgetsFlutterBinding.ensureInitialized();

  // await storeBaseURL();
  //await storeBearerToken('');
  // late String? t;
  // try{
  //   t = await getBearerToken();
  //   //
  //
  //
  //   if(t!.isEmpty || t == null || t == ''){
  //     await storeBearerToken('');
  //   }
  //
  // }catch(e){
  //   Log.d(e);
  //   await storeBearerToken('');
  // }finally{
  //   Log.d('Bearer token: ${t!}');
  // }

  //await FlutterSecureStorage().deleteAll();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstLaunch', true);

  await dotenv.load(); // Loading the .env file
  String? baseurl = dotenv.env['baseURL'];
  API.setBaseURL(baseurl!);
  await storeBaseURL();
  print('.env baseURL: $baseurl'); // Use the environment variable
  print('Sahil For You -> ${await getBaseURL()}');

  await deleteDatabase();

  initializeNotifications();

  // runApp(const App());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(
            create: (_) => ClassConfirmAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => ClassAttendanceHomeViewModel()),
        ChangeNotifierProvider(
            create: (context) => ClassAttendanceViewModel(context)),
        ChangeNotifierProvider(create: (_) => StudentViewModel()),
      ],
      child: MyApp(),
      // child: FutureBuilder<String?>(
      //   future: getBearerToken(), // Call to check if token exists
      //   builder: (context, snapshot) {
      //       // return SplashScreen();
      //     if (snapshot.hasData && snapshot.data != null) {
      //       return NewClassAttendanceHomeScreen(); // Show HomeScreen if token exists
      //     } else {
      //       return MyApp(); // Show splash screen if no token
      //     }
      //   },
      // ),
    ),
  );

  // final db = AppDatabase();
  // final studentDao = StudentDao(db);
  //
  // // Insert a sample student
  // await studentDao.insertStudent(StudentsCompanion(
  //   id: Value('101'),
  //   fullName: Value('Sahil Lalani'),
  //   pgIds: Value('111'),
  //   currentClassId: Value('12B'),
  //   currentRollNo: Value('43'),
  //   status: Value('active'),
  //   ppsp: Value('NA'),
  // ));
  //
  // // Fetch a student by ID
  // final student = await studentDao.getStudentById('101');
  // if (student != null) {
  //   print('Student Found: ${student.fullName}');
  // } else {
  //   print('No student found with the given ID.');
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    late String initialRoute;

    return ScreenUtilInit(
      designSize: Size(375, 819),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return FutureBuilder<String?>(
          future: getBearerToken(), // Fetch token
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // ✅ Show loading screen while waiting
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                      child:
                          CircularProgressIndicator(color: Colors.deepOrange)),
                ),
              );
            } else if (snapshot.hasError) {
              // ✅ Show error screen if Future fails
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                ),
              );
            }

            // ✅ Choose initial route based on token
            initialRoute = (snapshot.data == null || snapshot.data!.isEmpty)
                ? '/' // If no token, go to Splash
                : '/nclsatthome'; // If token exists, go to Home

            // if(Navigator.canPop(context)){
            //   Navigator.popUntil(context,(route) => false,);
            // }

            // return PopScope(
            //   canPop: false, // Prevent default back button behavior
            //   onPopInvoked: (didPop) async {
            //     if (didPop) {
            //       return;
            //     }
            //
            //     // Show confirmation dialog
            //     final bool shouldPop = await showDialog(
            //       context: context,
            //       builder: (context) => AlertDialog(
            //         title: Text('Are you sure?'),
            //         content: Text('Do you want to close the application?'),
            //         actions: [
            //           TextButton(
            //             onPressed: () => Navigator.pop(context, false),
            //             child: Text('No'),
            //           ),
            //           TextButton(
            //             onPressed: () => Navigator.pop(context, true),
            //             child: Text('Yes'),
            //           ),
            //         ],
            //       ),
            //     ) ?? false;
            //
            //     if (shouldPop) {
            //       Navigator.popUntil(context,(route)=>false);
            //     }
            //   },
            //   child: MaterialApp(
            //   debugShowCheckedModeBanner: false,
            //   theme: ThemeData(
            // primarySwatch: Colors.deepOrange,
            // textTheme: GoogleFonts.poppinsTextTheme(),
            // useMaterial3: true
            // ),
            // navigatorKey: navigatorKey,
            // initialRoute: initialRoute,
            // routes: {
            // '/': (context) => SplashScreen(),
            // '/login': (context) => LoginScreen(),
            // '/register': (context) => RegistrationScreen(),
            // '/home': (context) => HomeScreen(),
            // '/att': (context) => ManualAttendanceScreen(),
            // '/cattcon': (context) => ClassConfirmAttendanceScreen(),
            // '/clsatthome': (context) => ClassAttendanceHomeScreen(),
            // '/clsatt': (context) => ClassAttendanceScreen(),
            // '/stlst': (context) => StudentListingScreen(),
            // '/stpfp': (context) {
            // final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
            // return StudentProfileScreen(
            // studentData: args?['studentData'] ?? {},
            // className: args?['className'] ?? '',
            // );
            // },
            // // '/stpfp': (context) => StudentProfileScreen(),
            // '/nclsatthome': (context) => NewClassAttendanceHomeScreen(),
            // '/birthdays' : (context) => BirthdaySearchScreen(),
            // // In your main.dart or routes
            // '/test': (context) => TestSearchScreen(),
            //
            // },));

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.deepOrange,
                  textTheme: GoogleFonts.poppinsTextTheme(),
                  useMaterial3: true),
              navigatorKey: navigatorKey,
              //initialRoute: null,
              home: initialRoute == '/'
                  ? SplashScreen()
                  : NewClassAttendanceHomeScreen(),
              // routes: {
              //   '/': (context) => SplashScreen(),
              //   '/login': (context) => LoginScreen(),
              //   '/register': (context) => RegistrationScreen(),
              //   '/home': (context) => HomeScreen(),
              //   '/att': (context) => ManualAttendanceScreen(),
              //   '/cattcon': (context) => ClassConfirmAttendanceScreen(),
              //   '/clsatthome': (context) => ClassAttendanceHomeScreen(),
              //   '/clsatt': (context) => ClassAttendanceScreen(),
              //   '/stlst': (context) => StudentListingScreen(),
              //   '/stpfp': (context) {
              //     final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
              //     return StudentProfileScreen(
              //       studentData: args?['studentData'] ?? {},
              //       className: args?['className'] ?? '',
              //     );
              //   },
              //   // '/stpfp': (context) => StudentProfileScreen(),
              //   '/nclsatthome': (context) => NewClassAttendanceHomeScreen(),
              //   '/birthdays' : (context) => BirthdaySearchScreen(),
              //   // In your main.dart or routes
              //   '/test': (context) => TestSearchScreen(),
              //
              // },
              // onGenerateRoute: (RouteSettings settings) {
              //   switch (settings.name) {
              //     case '/':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             SplashScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           // Fade transition for SplashScreen
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/login':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             LoginScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           // Slide transition from right for LoginScreen
              //           const begin = Offset(1.0, 0.0);
              //           const end = Offset.zero;
              //           final tween =
              //           Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
              //           return SlideTransition(
              //             position: animation.drive(tween),
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/register':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             RegistrationScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           // Fade transition for RegistrationScreen
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/home':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             HomeScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           // Fade transition for HomeScreen
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/att':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             ManualAttendanceScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           // Customize this transition as needed
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/cattcon':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             ClassConfirmAttendanceScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/clsatthome':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             ClassAttendanceHomeScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/clsatt':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             ClassAttendanceScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/stlst':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             StudentListingScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/stpfp':
              //     // Extract arguments passed with Navigator.pushNamed
              //       final args = settings.arguments as Map<String, dynamic>?;
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             StudentProfileScreen(
              //               studentData: args?['studentData'] ?? {},
              //               className: args?['className'] ?? '',
              //             ),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           // Slide transition from right for StudentProfileScreen
              //           const begin = Offset(1.0, 0.0);
              //           const end = Offset.zero;
              //           final tween =
              //           Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
              //           return SlideTransition(
              //             position: animation.drive(tween),
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/nclsatthome':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             NewClassAttendanceHomeScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           // Fade transition for the new home screen
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/birthdays':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             BirthdaySearchScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     case '/test':
              //       return PageRouteBuilder(
              //         settings: settings,
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             TestSearchScreen(),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           // Customize this transition as needed
              //           return FadeTransition(
              //             opacity: animation,
              //             child: child,
              //           );
              //         },
              //       );
              //     default:
              //     // Fallback for undefined routes
              //       return MaterialPageRoute(
              //         builder: (context) => Scaffold(
              //           appBar: AppBar(title: Text("Screen Not Found")),
              //           body: Center(child: Text("Screen Not Found")),
              //         ),
              //       );
              //   }
              // }, // Defined in your routes file
            );
          },
        );
      },
    );

    //   return FutureBuilder<String?>(
    //       future: getBearerToken(),
    //       builder: (context, snapshot) {
    //         // Check if the Future is complete
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           // Show a loading screen while fetching the value
    //           return MaterialApp(
    //             home: Scaffold(
    //               body: Center(child: CircularProgressIndicator(color: Colors.deepOrange,)),
    //             ),
    //           );
    //         }
    //         else if (snapshot.hasError) {
    //           // Show an error screen if the Future fails
    //           return MaterialApp(
    //             home: Scaffold(
    //               body: Center(child: Text('Error: ${snapshot.error}')),
    //             ),
    //           );
    //         }
    //
    //         String initialRoute = (snapshot.data == null || snapshot.data!.isEmpty) ? '/' : '/nclsatthome';
    //
    //         return MaterialApp(
    //           //color: Color(0xFFED7902),
    //           theme: ThemeData(
    //             primarySwatch: Colors.deepOrange,
    //             // Apply Poppins to the entire app
    //             textTheme: GoogleFonts.poppinsTextTheme(),
    //           ),
    //           navigatorKey: navigatorKey,
    //           debugShowCheckedModeBanner: false,
    //           initialRoute: initialRoute,//initialRoute,
    //           routes: {
    //             '/': (context) => SplashScreen(),
    //             '/login': (context) => LoginScreen(),
    //             '/register': (context) => RegistrationScreen(),
    //             '/home': (context) => HomeScreen(),
    //             '/att': (context) => ManualAttendanceScreen(),
    //             '/cattcon': (context) => ClassConfirmAttendanceScreen(),
    //             '/clsatthome': (context) => ClassAttendanceHomeScreen(),
    //             '/clsatt': (context) => ClassAttendanceScreen(),
    //             '/stlst': (context) => StudentListingScreen(),
    //             '/stpfp': (context) {
    //               final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    //               return StudentProfileScreen(
    //                 studentData: args?['studentData'] ?? {},
    //                 className: args?['className'] ?? '',
    //               );
    //             },
    //             // '/stpfp': (context) => StudentProfileScreen(),
    //             '/nclsatthome': (context) => NewClassAttendanceHomeScreen(),
    //             '/birthdays' : (context) => BirthdaySearchScreen(),
    //
    //           },
    //       //   );
    //       // }
    //   );
    // });
  }
}

// /// The main app.
// class App extends StatelessWidget {
//   /// Constructs a [MyApp]
//   const App({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routerConfig: router,
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//
//       home: FutureBuilder<String?>(
//         future: getBearerToken(), // Call to check if token exists
//         builder: (context, snapshot) {
//             // return SplashScreen();
//           if (snapshot.hasData && snapshot.data != null) {
//             return HomeScreen(); // Show HomeScreen if token exists
//           } else {
//             return const SplashScreen(); // Show splash screen if no token
//           }
//         },
//       ),
//     );
//   }
// }
//
