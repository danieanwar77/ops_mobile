import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  final String content;

  const CustomText({
    Key? key,
    required this.content,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Text(content,
      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)
    );
  }
}
