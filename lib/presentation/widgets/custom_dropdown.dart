import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabeledDropdownButton2 extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final String hint;
  final ValueChanged<String?> onChanged;

  const LabeledDropdownButton2({
    super.key,
    required this.label,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.value,
  });

  List<DropdownMenuItem<String>> _buildMenuItems() {
    return items.map((item) {
      final bool isSelected = item == value;
      return DropdownMenuItem<String>(
        value: item,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          color: isSelected ? const Color(0xFFFAECEC) : Colors.transparent,
          alignment: Alignment.centerLeft,
          child: Text(
            item,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ),
      );
    }).toList();
  }

  Color get _borderColor =>
      value != null ? Colors.black : const Color(0xFF969AB8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 339.w,
      height: 39.h,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: value != null ? label : null,
          labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide:
                BorderSide(color: const Color(0xFF969AB8), width: 0.5.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide:
                BorderSide(color: const Color(0xFF969AB8), width: 0.5.w),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: _buildMenuItems(),
            value: value,
            onChanged: onChanged,
            customButton: Container(
              width: 339.w,
              height: 39.h,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      value ?? hint,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        height: 1.5,
                        color: value != null
                            ? Colors.black
                            : const Color(0xFF969AB8),
                        letterSpacing: 0.01.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 20.sp,
                    color: const Color(0xFF969AB8),
                  ),
                ],
              ),
            ),
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.zero,
              width: 339.w,
              height: 39.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: const Color(0xFF969AB8), width: 0.5.w),
                borderRadius: BorderRadius.circular(6.r),
              ),
              elevation: 0,
            ),
            dropdownStyleData: DropdownStyleData(
              width: 339.w,
              offset: Offset(-14.w, -10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 0.5.w),
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
            ),
          ),
        ),
      ),
    );

    // InputDecorator(
    //   decoration: InputDecoration(
    //     labelText: value != null ? label : null,
    //     labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
    //     contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(6.r),
    //       borderSide: BorderSide(color: const Color(0xFF969AB8), width: 0.5.w),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(6.r),
    //       borderSide: BorderSide(color: const Color(0xFF969AB8), width: 0.5.w),
    //     ),
    //   ),
    //   child: DropdownButtonHideUnderline(
    //     child: DropdownButton2<String>(
    //       isExpanded: true,
    //       items: _buildMenuItems(),
    //       value: value,
    //       onChanged: onChanged,
    //       customButton: Container(
    //         width: 339.w,
    //         height: 39.h,
    //         color: Colors.white,
    //         child: Stack(
    //           children: [
    //             Positioned(
    //               left: 14.w,
    //               top: 9.h,
    //               right: 40.w, // Add right padding for icon
    //               child: Text(
    //                 value ?? hint,
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.w400,
    //                   fontSize: 14.sp,
    //                   height: 1.5,
    //                   color: value != null
    //                       ? Colors.black
    //                       : const Color(0xFF969AB8),
    //                   letterSpacing: 0.01.sp,
    //                 ),
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //             ),
    //             Positioned(
    //               right: 12.w,
    //               top: 8.h,
    //               child: Icon(
    //                 CupertinoIcons.chevron_down,
    //                 size: 20.sp,
    //                 color: const Color(0xFF969AB8),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       buttonStyleData: ButtonStyleData(
    //         padding: EdgeInsets.zero,
    //         width: 339.w,
    //         height: 39.h,
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           border: Border.all(color: const Color(0xFF969AB8), width: 0.5.w),
    //           borderRadius: BorderRadius.circular(6.r),
    //         ),
    //         elevation: 0,
    //       ),
    //       dropdownStyleData: DropdownStyleData(
    //         width: 339.w,
    //         offset: Offset(-11, -10.h), // Adjust dropdown position
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           border: Border.all(color: Colors.white, width: 0.5.w),
    //           borderRadius: BorderRadius.circular(6.r),
    //         ),
    //       ),
    //       menuItemStyleData: MenuItemStyleData(
    //         padding: EdgeInsets.symmetric(horizontal: 1.w),
    //         //height: 40.h,
    //         // padding: EdgeInsets.zero,
    //       ),
    //     ),
    //   ),
    // );
  }
}
