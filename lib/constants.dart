import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetsPath {
  // static const String labels = 'assets/plant_disease_labels.txt';
  // static const String model = 'assets/plant_disease_detection-416_2.tflite';
  static const String labels = 'assets/plant_disease_labels.txt';
  static const String model = 'assets/plant_disease_detection.tflite';
}
class PredictionConsts{
  static const rect = 'rect';
  static const confidence = 'confidenceInClass';
  static const detectedClass = 'detectedClass';
}

class BoundingBoxConst {
  static const w = 'w';
  static const h = 'h';
  static const x = 'x';
  static const y = 'y';
}

