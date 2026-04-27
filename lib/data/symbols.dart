import 'package:flutter/material.dart';

enum SymbolKind { fruit, special, onceMore }

class GameSymbol {
  final String type;
  final String? baseType;
  final String display;
  final int prize;
  final String message;
  final bool isMini;
  final SymbolKind kind;

  const GameSymbol({
    required this.type,
    this.baseType,
    required this.display,
    required this.prize,
    required this.message,
    this.isMini = false,
    this.kind = SymbolKind.fruit,
  });

  String get effectiveType => baseType ?? type;
  bool get isOnceMore => kind == SymbolKind.onceMore;
}

const Map<String, GameSymbol> kSymbols = {
  'cherry':       GameSymbol(type: 'cherry',       display: '🍒', prize: 2,   message: 'CEREZAS'),
  'mini_cherry':  GameSymbol(type: 'mini_cherry',  baseType: 'cherry',     display: '🍒', prize: 1, message: 'MINI CEREZA',     isMini: true),
  'apple':        GameSymbol(type: 'apple',        display: '🍎', prize: 5,   message: 'MANZANAS'),
  'mini_apple':   GameSymbol(type: 'mini_apple',   baseType: 'apple',      display: '🍎', prize: 2, message: 'MINI MANZANA',    isMini: true),
  'orange':       GameSymbol(type: 'orange',       display: '🍊', prize: 10,  message: 'NARANJAS'),
  'mini_orange':  GameSymbol(type: 'mini_orange',  baseType: 'orange',     display: '🍊', prize: 2, message: 'MINI NARANJA',    isMini: true),
  'lemon':        GameSymbol(type: 'lemon',        display: '🍋', prize: 10,  message: 'LIMONES'),
  'mini_lemon':   GameSymbol(type: 'mini_lemon',   baseType: 'lemon',      display: '🍋', prize: 2, message: 'MINI LIMÓN',      isMini: true),
  'watermelon':   GameSymbol(type: 'watermelon',   display: '🍉', prize: 20,  message: 'SANDÍAS'),
  'mini_watermelon': GameSymbol(type: 'mini_watermelon', baseType: 'watermelon', display: '🍉', prize: 2, message: 'MINI SANDÍA', isMini: true),
  'bell':         GameSymbol(type: 'bell',         display: '🔔', prize: 10,  message: 'CAMPANAS'),
  'mini_bell':    GameSymbol(type: 'mini_bell',    baseType: 'bell',       display: '🔔', prize: 2, message: 'MINI CAMPANA',    isMini: true),
  'star':         GameSymbol(type: 'star',         display: '🌟', prize: 30,  message: '¡ESTRELLA!'),
  'mini_star':    GameSymbol(type: 'mini_star',    baseType: 'star',       display: '🌟', prize: 2, message: 'MINI ESTRELLA',   isMini: true),
  'seven':        GameSymbol(type: 'seven',        display: '7',  prize: 40,  message: '¡SIETE DE LA SUERTE!'),
  'mini_seven':   GameSymbol(type: 'mini_seven',   baseType: 'seven',      display: '7',  prize: 2, message: 'MINI 7',          isMini: true),
  'bar':          GameSymbol(type: 'bar',          display: 'BAR', prize: 100, message: '¡BAR ROJO!'),
  'mini_bar':     GameSymbol(type: 'mini_bar',     baseType: 'bar',        display: 'BAR', prize: 2, message: 'MINI BAR',       isMini: true),
  'once_more':    GameSymbol(type: 'once_more',    display: 'ONCE\nMORE', prize: 0, message: '¡EVENTO ESPECIAL!', kind: SymbolKind.onceMore),
};

const List<String> kBetTypes = [
  'apple', 'watermelon', 'star',
  'lemon', 'orange', 'bell',
  'cherry', 'seven', 'bar',
];

GameSymbol symbolByType(String t) => kSymbols[t]!;

class SymbolColors {
  static const Color seven = Color(0xFFE53E3E);
  static const Color barBg = Color(0xFFDC2626);
  static const Color onceMore = Color(0xFF22D3EE);
}
