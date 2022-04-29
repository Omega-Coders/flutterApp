import 'dart:ffi';

import 'package:image/image.dart';
import 'dart:io';

String copyCrop(String src_, int x, int y, w, int h) {
  // Make sure crop rectangle is within the range of the src image.

  final src = decodeImage(File(src_).readAsBytesSync())!;
  //x = x.clamp(0, src.width - 1).toInt();
  print(src_ + "************1");

  x = x.clamp(0, src.width - 1).toInt();
  y = y.clamp(0, src.height - 1).toInt();
  if (x + w > src.width) {
    w = src.width - x;
  }
  if (y + h > src.height) {
    h = src.height - y;
  }

  final dst =
      Image(w, h, channels: src.channels, exif: src.exif, iccp: src.iccProfile);

  for (var yi = 0, sy = y; yi < h; ++yi, ++sy) {
    for (var xi = 0, sx = x; xi < w; ++xi, ++sx) {
      dst.setPixel(xi, yi, src.getPixel(sx, sy));
    }
  }
  File(src_).writeAsBytesSync(encodeJpg(dst));

  return src_;
}

String ReSize(String src_) {
  final src = decodeImage(File(src_).readAsBytesSync())!;
  Image thumbnail = copyResize(src, width: 4000, height: 4000);

  File(src_).delete();
  if (File(src_).existsSync()) {
    print(src_ + "************");
  }

  File(src_).writeAsBytesSync(encodePng(thumbnail),
      mode: FileMode.append, flush: true);

  return src_;
}
