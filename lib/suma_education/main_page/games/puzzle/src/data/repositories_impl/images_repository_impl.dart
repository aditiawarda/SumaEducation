import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/domain/models/puzzle_image.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/domain/repositories/images_repository.dart';

const puzzleOptions = <PuzzleImage>[
  PuzzleImage(
    name: 'Numeric',
    assetPath: 'assets/images/numeric-puzzle.png',
    soundPath: '',
  ),
  PuzzleImage(
    name: 'Lion',
    assetPath: 'assets/animals/1_suma.jpeg',
    soundPath: 'assets/sounds/lion.mp3',
  ),
  PuzzleImage(
    name: 'Cat',
    assetPath: 'assets/animals/2_tio.jpeg',
    soundPath: 'assets/sounds/cat.mp3',
  ),
  PuzzleImage(
    name: 'Dog',
    assetPath: 'assets/animals/3_mia.jpeg',
    soundPath: 'assets/sounds/dog.mp3',
  ),
  PuzzleImage(
    name: 'Fox',
    assetPath: 'assets/animals/4_paima.jpeg',
    soundPath: 'assets/sounds/fox.mp3',
  ),
  PuzzleImage(
    name: 'Koala',
    assetPath: 'assets/animals/5_lindung.jpeg',
    soundPath: 'assets/sounds/koala.mp3',
  ),
  PuzzleImage(
    name: 'Monkey',
    assetPath: 'assets/animals/6_eddie.jpeg',
    soundPath: 'assets/sounds/monkey.mp3',
  ),
  PuzzleImage(
    name: 'Mouse',
    assetPath: 'assets/animals/7_arini.jpeg',
    soundPath: 'assets/sounds/mouse.mp3',
  ),
];

Future<Image> decodeAsset(ByteData bytes) async {
  return decodeImage(
    bytes.buffer.asUint8List(),
  )!;
}

class SPlitData {
  final Image image;
  final int crossAxisCount;

  SPlitData(this.image, this.crossAxisCount);
}

Future<List<Uint8List>> splitImage(SPlitData data) {
  final image = data.image;
  final crossAxisCount = data.crossAxisCount;
  final int length = (image.width / crossAxisCount).round();
  List<Uint8List> pieceList = [];

  for (int y = 0; y < crossAxisCount; y++) {
    for (int x = 0; x < crossAxisCount; x++) {
      pieceList.add(
        Uint8List.fromList(
          encodePng(
            copyCrop(
              image,
              x * length,
              y * length,
              length,
              length,
            ),
          ),
        ),
      );
    }
  }
  return Future.value(pieceList);
}

class ImagesRepositoryImpl implements ImagesRepository {
  Map<String, Image> cache = {};

  @override
  Future<List<Uint8List>> split(String asset, int crossAxisCount) async {
    late Image image;
    if (cache.containsKey(asset)) {
      image = cache[asset]!;
    } else {
      final bytes = await rootBundle.load(asset);

      /// use compute because theimage package is a pure dart package
      /// so to avoid bad ui performance we do this task in a different
      /// isolate
      image = await compute(decodeAsset, bytes);

      final width = math.min(image.width, image.height);

      /// convert to square
      image = copyResizeCropSquare(image, width);
      cache[asset] = image;
    }

    final pieces = await compute(
      splitImage,
      SPlitData(image, crossAxisCount),
    );

    return pieces;
  }
}
