import 'package:desease_plant_detection/image_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ImagePicker _imagePicker;
  XFile? image;


  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant disease detection'),
      ),
      body: Builder(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                height: 0.5.sh,
                width: 0.5.sw,
                'assets/plant_image.png',
                alignment: Alignment.center,
              ),
            ),
            Text('Выберите ресурс для загрузки изображения',
                textAlign: TextAlign.center,
                style:
                    DefaultTextStyle.of(context).style.copyWith(fontSize: 20.sp)
                // style: TextStyle(fontSize: 15.sp),
                ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      initImagePicker(ImageSource.camera).then((value) => imageIsNoNull(value));


                    },
                    child: const Text('Camera'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        initImagePicker(ImageSource.gallery).then((value) => imageIsNoNull(
                            value));
                      },
                      child: const Text('Gallery'))
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Future<XFile?> initImagePicker(ImageSource source) async {
    setState(() {});
    if (source == ImageSource.gallery) {
      image = await _imagePicker.pickImage(source: source);
    } else if (source == ImageSource.camera) {
      image = await _imagePicker.pickImage(source: source);
    }
    return image;

    // final  LostDataResponse response = await _imagePicker.retrieveLostData();
    // if(response.isEmpty) return;
    // final List<XFile>? files = response.files;
  }
  void imageIsNoNull(XFile? image) {
    if (image != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageShowPage(file: image)));
    }
  }

}
