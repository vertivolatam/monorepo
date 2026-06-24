import 'token_service.dart';

class AppMotion {
  static Duration get short =>
      Duration(milliseconds: TokenService.instance.tokens.motion.short);
  static Duration get medium =>
      Duration(milliseconds: TokenService.instance.tokens.motion.medium);
  static Duration get long =>
      Duration(milliseconds: TokenService.instance.tokens.motion.long);
}
