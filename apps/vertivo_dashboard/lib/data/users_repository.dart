import 'package:vertivo_client/vertivo_client.dart';

/// Reads users across all segments for the admin users page.
///
/// `user.listBySegment` takes one segment, so we query the known segments and
/// concatenate. (No `user.listAll` endpoint exists; if a new segment is added
/// server-side it must be added here — registered as a follow-up.)
class UsersRepository {
  final Client client;
  const UsersRepository(this.client);

  static const segments = ['residential', 'commercial', 'industrial', 'expert'];

  Future<List<User>> fetchAll() async {
    final users = <User>[];
    for (final s in segments) {
      users.addAll(await client.user.listBySegment(s, limit: 100, offset: 0));
    }
    return users;
  }
}
