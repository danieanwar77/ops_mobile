import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ops_mobile/core/core/constant/constant.dart';


class CustomTextH1Primary extends StatelessWidget {
  final String content;

  const CustomTextH1Primary({
    Key? key,
    required this.content
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(content,
      style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: primaryColor
      ),
    );
  }
}

class CustomTextH2Green extends StatelessWidget {
  final String content;
  const CustomTextH2Green({
    Key? key,
    required this.content
  }): super(key: key);

   @override
   Widget build(BuildContext context) {
     return Text(content,
       style: TextStyle(
           color: green,
           fontSize: 12.sp,
           fontWeight: FontWeight.w700
       ),
     );
   }
 }



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

class CustomTextDetail extends StatelessWidget {
  final String content;

  const CustomTextDetail({
    Key? key,
    required this.content
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(content,
    style: TextStyle(fontSize: 12.sp)
    );
  }
}

