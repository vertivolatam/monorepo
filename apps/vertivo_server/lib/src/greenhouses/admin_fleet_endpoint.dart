import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Admin-only fleet view across ALL tenants.
///
/// The 13 existing endpoints are per-tenant (`greenhouse.listByUser` filters by
/// `session.authenticated.userIdentifier`) or per-greenhouse. None of them can
/// list the whole fleet, which the operator cockpit (`vertivo_dashboard`) needs.
///
/// Access is restricted to sessions holding [Scope.admin]. Overriding
/// [requiredScopes] implicitly enables [requireLogin], so Serverpod rejects any
/// unauthenticated or non-admin caller before the method body runs — no manual
/// scope check is needed here.
///
/// NOTE on roles: there is no roles table or `User.isAdmin` field yet
/// (`User.segment` is residential/commercial/industrial/expert, not an
/// authorization role). The `serverpod.admin` scope is granted via the auth
/// token. A real RBAC system is a separate change.
class AdminFleetEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  /// List the entire active fleet across every tenant, ordered by owner.
  ///
  /// Paginated (`limit`/`offset`) so the cockpit can page large fleets.
  Future<List<Greenhouse>> listAll(
    Session session, {
    int limit = 500,
    int offset = 0,
  }) async {
    return await Greenhouse.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.userId,
    );
  }
}
