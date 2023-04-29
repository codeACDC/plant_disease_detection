import 'dart:io';

import 'package:desease_plant_detection/bounding_box_widget.dart';
import 'package:desease_plant_detection/result_display_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:desease_plant_detection/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class ImageShowPage extends StatefulWidget {
  static const String id = 'image_show_page';
  final XFile file;

  const ImageShowPage({Key? key, required this.file}) : super(key: key);

  @override
  State<ImageShowPage> createState() => _ImageShowPageState();
}

class _ImageShowPageState extends State<ImageShowPage> {
  late ValueNotifier<List?> recognitionNotifier;
  double? imageHeight;
  void setImageHeight() async {
    var temp =
        await decodeImageFromList(File(widget.file.path).readAsBytesSync());
    setState(() {
      imageHeight = temp.height.toDouble();
    });
  }

  @override
  void initState() {
    setImageHeight();
    runModel();
    recognitionNotifier = ValueNotifier<List?>(null);
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  void runModel() async {
    await Tflite.loadModel(
      model: AssetsPath.model,
      labels: AssetsPath.labels,
      // useGpuDelegate: true
    );
    setState(() {
      recognition().then((value) {
        setState(() {
          recognitionNotifier = ValueNotifier<List?>(value);
        });
      });
    });
    print(recognitionNotifier.value);
    // recognition().then((value) {
    //   super.setState(() {
    //     recognitionNotifier = ValueNotifier<List?>(value);
    //   });
    // }).onError((error, stackTrace) {
    //   debugPrint(error.toString());
    // });
  }

  Future<List?> recognition() async {
    // Uint8List bytes = File(widget.file.path).readAsBytes();
    // img.Image? image = img.decodeImage(bytes);
    // img.Image resizedImage = img.copyResize(image!, width: 416, height: 416);
    // Uint8List resizedImageBytes =
    //     Uint8List.fromList(img.encodePng(resizedImage));
    // return Tflite.detectObjectOnBinary(
    //   binary: imageToByteListFloat32(resizedImage, 416, 0.0, 255),
    //   model: 'YOLO',
    //   asynch: false,
    //   threshold: 0.3,
    //   numResultsPerClass: 2,
    // );
    var recognition = await Tflite.detectObjectOnImage(
      path: widget.file.path,
      model: 'YOLO',
      imageMean: 0,
      imageStd: 255,
      asynch: true,
      threshold: 0.3,
      numResultsPerClass: 2,
    );
    return recognition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection results:'),
      ),
      body: ValueListenableBuilder(
          valueListenable: recognitionNotifier,
          builder: (context, value, _) {
            if (value != null && imageHeight != null) {
              print(value);
              return Stack(
                children: [
                  SizedBox(
                    width: 1.sw,
                    child: Image.file(
                        fit: BoxFit.fitWidth, File(widget.file.path)),
                  ),

                  BoundingBoxWidget(
                      prediction: value, imageHeight: imageHeight ?? 0),
                  value.isNotEmpty
                      ? ResultDisplayingWidget(recognition: value)
                      : Container(),

                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }),
    );
  }

// Uint8List imageToByteListFloat32(
//     img.Image image, int inputSize, double mean, double std) {
//   var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
//   var buffer = Float32List.view(convertedBytes.buffer);
//   int pixelIndex = 0;
//   for (var i = 0; i < inputSize; i++) {
//     for (var j = 0; j < inputSize; j++) {
//       var pixel = image.getPixel(j, i);
//       buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
//       buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
//       buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
//     }
//   }
//   return convertedBytes.buffer.asUint8List();
// }
}

