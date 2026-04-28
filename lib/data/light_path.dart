/// Order in which the moving "light" visits the 24 perimeter slots
/// of the 7x7 board (clockwise from top-left).
///
/// Visual board layout (7 cols x 7 rows). Center 5x5 is the message panel.
///
///  [ 0][ 1][ 2][ 3][ 4][ 5][ 6]
///  [23][                   ][ 7]
///  [22][                   ][ 8]
///  [21][      CENTRO       ][ 9]
///  [20][                   ][10]
///  [19][                   ][11]
///  [18][17][16][15][14][13][12]
const List<int> kLightPath = [
  0, 1, 2, 3, 4, 5, 6,
  7, 8, 9, 10, 11,
  12, 13, 14, 15, 16, 17, 18,
  19, 20, 21, 22, 23,
];

/// Maps a slot id (0..23) to its (col, row) position on the 7x7 grid.
/// Used by the UI layer to position cells with Stack/Positioned.
const Map<int, ({int col, int row})> kSlotGridPos = {
  // Top row (left → right)
  0:  (col: 0, row: 0), 1:  (col: 1, row: 0), 2:  (col: 2, row: 0), 3:  (col: 3, row: 0),
  4:  (col: 4, row: 0), 5:  (col: 5, row: 0), 6:  (col: 6, row: 0),
  // Right column (top → bottom, after corner)
  7:  (col: 6, row: 1), 8:  (col: 6, row: 2), 9:  (col: 6, row: 3),
  10: (col: 6, row: 4), 11: (col: 6, row: 5),
  // Bottom row (right → left, including bottom-right corner)
  12: (col: 6, row: 6), 13: (col: 5, row: 6), 14: (col: 4, row: 6), 15: (col: 3, row: 6),
  16: (col: 2, row: 6), 17: (col: 1, row: 6), 18: (col: 0, row: 6),
  // Left column (bottom → top, after corner)
  19: (col: 0, row: 5), 20: (col: 0, row: 4), 21: (col: 0, row: 3),
  22: (col: 0, row: 2), 23: (col: 0, row: 1),
};
