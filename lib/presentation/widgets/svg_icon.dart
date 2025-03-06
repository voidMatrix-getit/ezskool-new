import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

//SvgPicture.asset('assets/cal.svg', width: 18.w, height: 18.h),

class SvgIcon extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;

  const SvgIcon({
    required this.assetName,
    required this.size,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      // color: color,
    );
  }
}
