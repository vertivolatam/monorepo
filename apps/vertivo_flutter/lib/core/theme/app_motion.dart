import 'package:vertivolatam_ui/vertivolatam_ui.dart';

class AppMotion {
  static Duration get short =>
      Duration(milliseconds: VertivoTokens.tokens.motion.short);
  static Duration get medium =>
      Duration(milliseconds: VertivoTokens.tokens.motion.medium);
  static Duration get long =>
      Duration(milliseconds: VertivoTokens.tokens.motion.long);
}
