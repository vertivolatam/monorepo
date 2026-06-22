import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:vertivo_server/src/generated/protocol.dart';

// Import the generated test helper file (also re-exports serverpod_test).
// Run `serverpod generate` after adding the AdminFleetEndpoint so the
// `endpoints.adminFleet` accessor exists in this tool file.
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminFleetEndpoint', (sessionBuilder, endpoints) {
    // Seed two greenhouses owned by two DIFFERENT tenants, so a correct
    // cross-tenant listing must return both.
    setUp(() async {
      final session = sessionBuilder.build();
      await Greenhouse.db.insertRow(
        session,
        Greenhouse(
          userId: 'tenant-a',
          name: 'GH A',
          irrigationType: 'aeroponic',
          totalTrays: 1,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      await Greenhouse.db.insertRow(
        session,
        Greenhouse(
          userId: 'tenant-b',
          name: 'GH B',
          irrigationType: 'aeroponic',
          totalTrays: 1,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });

    // The test helper routes through EndpointDispatch, which throws a single
    // NotAuthorizedException for BOTH missing-login and missing-scope cases.
    test(
      'when caller is unauthenticated then listAll is rejected',
      () async {
        final unauth = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );
        await expectLater(
          endpoints.adminFleet.listAll(unauth, limit: 500, offset: 0),
          throwsA(isA<NotAuthorizedException>()),
        );
      },
    );

    test(
      'when caller is authenticated WITHOUT admin scope then listAll is rejected',
      () async {
        final nonAdmin = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            'tenant-a',
            {}, // no scopes
          ),
        );
        await expectLater(
          endpoints.adminFleet.listAll(nonAdmin, limit: 500, offset: 0),
          throwsA(isA<NotAuthorizedException>()),
        );
      },
    );

    test(
      'when caller has admin scope then listAll returns greenhouses across tenants',
      () async {
        final admin = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            'operator-1',
            {Scope.admin},
          ),
        );
        final fleet = await endpoints.adminFleet.listAll(admin, limit: 500, offset: 0);
        final owners = fleet.map((g) => g.userId).toSet();
        expect(owners, containsAll(<String>{'tenant-a', 'tenant-b'}));
      },
    );
  });
}
