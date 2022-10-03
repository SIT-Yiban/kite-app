/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// Source from https://github.com/boyan01/flutter-tetris
// All rights kept for original author.
//
// Imported and commented on 2022.8.28

import 'dart:math' as math;

import 'gamer.dart';

const BLOCK_SHAPES = {
  BlockType.I: [
    [1, 1, 1, 1]
  ],
  BlockType.L: [
    [0, 0, 1],
    [1, 1, 1],
  ],
  BlockType.J: [
    [1, 0, 0],
    [1, 1, 1],
  ],
  BlockType.Z: [
    [1, 1, 0],
    [0, 1, 1],
  ],
  BlockType.S: [
    [0, 1, 1],
    [1, 1, 0],
  ],
  BlockType.O: [
    [1, 1],
    [1, 1]
  ],
  BlockType.T: [
    [0, 1, 0],
    [1, 1, 1]
  ]
};

///方块初始化时的位置
const START_XY = {
  BlockType.I: [3, 0],
  BlockType.L: [4, -1],
  BlockType.J: [4, -1],
  BlockType.Z: [4, -1],
  BlockType.S: [4, -1],
  BlockType.O: [4, -1],
  BlockType.T: [4, -1],
};

///方块变换时的中心点
const ORIGIN = {
  BlockType.I: [
    [1, -1],
    [-1, 1],
  ],
  BlockType.L: [
    [0, 0]
  ],
  BlockType.J: [
    [0, 0]
  ],
  BlockType.Z: [
    [0, 0]
  ],
  BlockType.S: [
    [0, 0]
  ],
  BlockType.O: [
    [0, 0]
  ],
  BlockType.T: [
    [0, 0],
    [0, 1],
    [1, -1],
    [-1, 0]
  ],
};

enum BlockType { I, L, J, Z, S, O, T }

class Block {
  final BlockType type;
  final List<List<int>> shape;
  final List<int> xy;
  final int rotateIndex;

  Block(this.type, this.shape, this.xy, this.rotateIndex);

  Block fall({int step = 1}) {
    return Block(type, shape, [xy[0], xy[1] + step], rotateIndex);
  }

  Block right() {
    return Block(type, shape, [xy[0] + 1, xy[1]], rotateIndex);
  }

  Block left() {
    return Block(type, shape, [xy[0] - 1, xy[1]], rotateIndex);
  }

  Block rotate() {
    List<List<int>> result = List.filled(shape[0].length, const [], growable: false);
    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (result[col].isEmpty) {
          result[col] = List.filled(shape.length, 0, growable: false);
        }
        result[col][row] = shape[shape.length - 1 - row][col];
      }
    }
    final nextXy = [this.xy[0] + ORIGIN[type]![rotateIndex][0], this.xy[1] + ORIGIN[type]![rotateIndex][1]];
    final nextRotateIndex = rotateIndex + 1 >= ORIGIN[this.type]!.length ? 0 : rotateIndex + 1;

    return Block(type, result, nextXy, nextRotateIndex);
  }

  bool isValidInMatrix(List<List<int>> matrix) {
    if (xy[1] + shape.length > GAME_PAD_MATRIX_H || xy[0] < 0 || xy[0] + shape[0].length > GAME_PAD_MATRIX_W) {
      return false;
    }
    for (var i = 0; i < matrix.length; i++) {
      final line = matrix[i];
      for (var j = 0; j < line.length; j++) {
        if (line[j] == 1 && get(j, i) == 1) {
          return false;
        }
      }
    }
    return true;
  }

  ///return null if do not show at [x][y]
  ///return 1 if show at [x,y]
  int? get(int x, int y) {
    x -= xy[0];
    y -= xy[1];
    if (x < 0 || x >= shape[0].length || y < 0 || y >= shape.length) {
      return null;
    }
    return shape[y][x] == 1 ? 1 : null;
  }

  static Block fromType(BlockType type) {
    final shape = BLOCK_SHAPES[type];
    return Block(type, shape!, START_XY[type]!, 0);
  }

  static Block getRandom() {
    final i = math.Random().nextInt(BlockType.values.length);
    return fromType(BlockType.values[i]);
  }
}
