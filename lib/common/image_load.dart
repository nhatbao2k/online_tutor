import 'package:flutter/material.dart';

import '../res/images/image_view.dart';

class ImageLoad{
  static Widget imageNetwork(String? url, double? h, double w) {
    return Container(
      height: h,
      width: w,
      // ignore: unnecessary_null_comparison
      child: url == null
          ? Image.asset(
        ImageView.no_load,
        height: h,
        width: w,
        fit: BoxFit.cover,
      )
          : Image.network(
          url,
          height: h,
          fit: BoxFit.fill,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image(
              image: AssetImage(ImageView.no_load),
              height: h, fit: BoxFit.fill,);
          }
      ),
    );
  }
}