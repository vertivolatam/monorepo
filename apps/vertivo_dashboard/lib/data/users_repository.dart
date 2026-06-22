import 'package:vertivo_client/vertivo_client.dart';

/// Reads users across all segments for the admin users page.
///
/// `user.listBySegment` takes one segment, so we query the known segments and
/// concatenate. (No `user.listAll` endpoint exists; if a new segment is added
/// server-side it must be added here — registered as a follow-up.)
///
/// FUENTE DE VERDAD: `apps/vertivo_server/lib/src/users/user.spy.yaml`
///   `segment: String  # residential, commercial, industrial, expert`
///
/// El backend modela `User.segment` como un `String` libre, NO como un enum —
/// `vertivo_client` lo expone igual (`String segment`), así que no hay enum
/// generado del que iterar valores. Esta lista es, por tanto, una copia
/// paralela de los segments documentados en el `.spy.yaml`. Si el backend
/// migra `segment` a un enum (`UserSegment`), reemplazar esta lista por
/// `UserSegment.values` para eliminar el drift.
/// TODO(VRTV): proponer enum `UserSegment` en el server para volver esta lista
/// derivable y eliminar el drift silencioso.
class UsersRepository {
  final Client client;
  const UsersRepository(this.client);

  static const segments = ['residential', 'commercial', 'industrial', 'expert'];

  Future<List<User>> fetchAll() async {
    // Hace el drift visible si alguien vacía la lista por accidente.
    assert(segments.isNotEmpty, 'segments no puede estar vacío');
    final users = <User>[];
    for (final s in segments) {
      users.addAll(await client.user.listBySegment(s, limit: 100, offset: 0));
    }
    return users;
  }
}
