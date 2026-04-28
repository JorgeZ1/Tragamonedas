import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'util/sound_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await soundService.init();
  runApp(const ProviderScope(child: TragamonedasApp()));
}
