import 'package:logger/logger.dart';

class Log {
  static final _logger = Logger();

  static Logger getLogger(){
    return _logger;
  }

  static void d(Object e){
    _logger.d(e);
  }
}


// void main() {
//
//
//   logger.d("This is a debug message");
//   logger.i("Info message");
//   logger.w("Warning message");
//   logger.e("Error message");
//   logger.f("Fatal error message");
// }
