import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ops_mobile/utils/helper.dart';

class CustomImage extends StatelessWidget {
  final String path;

  const CustomImage({
    Key? key,
    required this.path
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(Helper.pathLocalOrServer(path)){
      debugPrint('print path local ${path}');
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace){
          return const Icon(
            Icons.image_outlined,
            color: Colors.grey,
          );
        },
      );
    }else{
      debugPrint('print path server ${path}');
      return Image.network(
        "${Helper.baseUrl()}/$path",
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace){
          return const Icon(
            Icons.image_outlined,
            color: Colors.grey,
          );
        },
      );
    }

  }
}
