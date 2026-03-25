import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  /// Get the authenticated user's profile
  Future<User?> getProfile(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final rows = await User.db.find(
      session,
      where: (t) => t.authIdentifier.equals(authInfo.userIdentifier),
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  /// Update user profile
  Future<User> updateProfile(
    Session session,
    User user,
  ) async {
    user.updatedAt = DateTime.now();
    return await User.db.updateRow(session, user);
  }

  /// Get user preferences
  Future<UserPreferences?> getPreferences(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final rows = await UserPreferences.db.find(
      session,
      where: (t) => t.userId.equals(authInfo.userIdentifier),
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  /// Update user preferences
  Future<UserPreferences> updatePreferences(
    Session session,
    UserPreferences preferences,
  ) async {
    preferences.updatedAt = DateTime.now();
    return await UserPreferences.db.updateRow(session, preferences);
  }

  /// Get user's subscription plan
  Future<SubscriptionPlan?> getSubscriptionPlan(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final rows = await SubscriptionPlan.db.find(
      session,
      where: (t) => t.userId.equals(authInfo.userIdentifier) & t.isActive.equals(true),
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  /// List users by segment (admin only)
  Future<List<User>> listBySegment(
    Session session,
    String segment, {
    int limit = 50,
    int offset = 0,
  }) async {
    return await User.db.find(
      session,
      where: (t) => t.segment.equals(segment),
      limit: limit,
      offset: offset,
    );
  }
}
