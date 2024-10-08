// import 'dart:ui';
//
// import 'package:flutter/material.dart' hide Image;
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
// class FacePainter extends CustomPainter {
//   final Image image;
//   final List<Face> faces;
//   final List<Rect> rects = [];
//
//   FacePainter(this.image, this.faces) {
//     for (var i = 0; i < faces.length; i++) {
//       rects.add(faces[i].boundingBox);
//     }
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5.0
//       ..color = Colors.yellow;
//
//     canvas.drawImage(image, Offset.zero, Paint());
//     for (var i = 0; i < faces.length; i++) {
//       canvas.drawRect(rects[i], paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(FacePainter oldDelegate) {
//     return image != oldDelegate.image || faces != oldDelegate.faces;
//   }
// }