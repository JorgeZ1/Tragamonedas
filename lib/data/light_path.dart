/// Order in which the moving "light" visits the 20 perimeter slots
/// of the 7x5 board. Indices match the original HTML's `data-id` mapping.
///
/// Visual board layout (7 cols x 5 rows). Center 5x3 is the message panel.
///
///  [ 0][ 1][ 2][ 3][ 4][ 5][ 6]
///  [19][      CENTRO       ][ 7]
///  [18][      CENTRO       ][ 8]
///  [17][      CENTRO       ][ 9]
///  [16][15][14][13][12][11][10]
const List<int> kLightPath = [
  0, 1, 2, 3, 4, 5, 6,
  7, 8, 9,
  10, 11, 12, 13, 14, 15, 16,
  17, 18, 19,
];

/// Maps a slot id (0..19) to its (col, row) position on the 7x5 grid.
/// Used by the UI layer to position cells with Stack/Positioned.
const Map<int, ({int col, int row})> kSlotGridPos = {
  0:  (col: 0, row: 0), 1:  (col: 1, row: 0), 2:  (col: 2, row: 0), 3:  (col: 3, row: 0),
  4:  (col: 4, row: 0), 5:  (col: 5, row: 0), 6:  (col: 6, row: 0),
  7:  (col: 6, row: 1), 8:  (col: 6, row: 2), 9:  (col: 6, row: 3),
  10: (col: 6, row: 4), 11: (col: 5, row: 4), 12: (col: 4, row: 4), 13: (col: 3, row: 4),
  14: (col: 2, row: 4), 15: (col: 1, row: 4), 16: (col: 0, row: 4),
  17: (col: 0, row: 3), 18: (col: 0, row: 2), 19: (col: 0, row: 1),
};
