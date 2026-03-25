import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class GreenhouseEndpoint extends Endpoint {
  /// Create a new greenhouse
  Future<Greenhouse> create(Session session, Greenhouse greenhouse) async {
    greenhouse.createdAt = DateTime.now();
    greenhouse.updatedAt = DateTime.now();
    greenhouse.isActive = true;
    return await Greenhouse.db.insertRow(session, greenhouse);
  }

  /// Get greenhouse by id
  Future<Greenhouse?> get(Session session, int id) async {
    return await Greenhouse.db.findById(session, id);
  }

  /// List greenhouses for the authenticated user
  Future<List<Greenhouse>> listByUser(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];
    return await Greenhouse.db.find(
      session,
      where: (t) => t.userId.equals(authInfo.userIdentifier) & t.isActive.equals(true),
    );
  }

  /// Update greenhouse settings
  Future<Greenhouse> update(Session session, Greenhouse greenhouse) async {
    greenhouse.updatedAt = DateTime.now();
    return await Greenhouse.db.updateRow(session, greenhouse);
  }

  /// Delete greenhouse (soft delete)
  Future<bool> delete(Session session, int id) async {
    final greenhouse = await Greenhouse.db.findById(session, id);
    if (greenhouse == null) return false;
    greenhouse.isActive = false;
    greenhouse.updatedAt = DateTime.now();
    await Greenhouse.db.updateRow(session, greenhouse);
    return true;
  }

  /// Get trays for a greenhouse
  Future<List<Tray>> getTrays(Session session, int greenhouseId) async {
    return await Tray.db.find(
      session,
      where: (t) => t.greenhouseId.equals(greenhouseId),
      orderBy: (t) => t.position,
    );
  }

  /// Get plants for a tray
  Future<List<Plant>> getPlants(Session session, int trayId) async {
    return await Plant.db.find(
      session,
      where: (t) => t.trayId.equals(trayId),
      orderBy: (t) => t.position,
    );
  }

  /// Create a tray in a greenhouse
  Future<Tray> createTray(Session session, Tray tray) async {
    tray.createdAt = DateTime.now();
    tray.updatedAt = DateTime.now();
    return await Tray.db.insertRow(session, tray);
  }

  /// Plant a new plant in a tray
  Future<Plant> createPlant(Session session, Plant plant) async {
    plant.createdAt = DateTime.now();
    plant.updatedAt = DateTime.now();
    plant.healthScore = 100.0;
    plant.isQuarantined = false;
    return await Plant.db.insertRow(session, plant);
  }

  /// Record an environmental reading
  Future<EnvironmentalReading> recordReading(
    Session session,
    EnvironmentalReading reading,
  ) async {
    reading.createdAt = DateTime.now();
    return await EnvironmentalReading.db.insertRow(session, reading);
  }

  /// Get environmental readings for a greenhouse
  Future<List<EnvironmentalReading>> getReadings(
    Session session,
    int greenhouseId,
    String measurementType, {
    int limit = 100,
  }) async {
    return await EnvironmentalReading.db.find(
      session,
      where: (t) =>
          t.greenhouseId.equals(greenhouseId) &
          t.measurementType.equals(measurementType),
      limit: limit,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Quarantine a plant
  Future<Plant?> quarantinePlant(
    Session session,
    int plantId,
    String reason,
  ) async {
    final plant = await Plant.db.findById(session, plantId);
    if (plant == null) return null;
    plant.isQuarantined = true;
    plant.quarantineReason = reason;
    plant.updatedAt = DateTime.now();
    return await Plant.db.updateRow(session, plant);
  }

  /// Record an irrigation event
  Future<IrrigationEvent> recordIrrigation(
    Session session,
    IrrigationEvent event,
  ) async {
    event.createdAt = DateTime.now();
    return await IrrigationEvent.db.insertRow(session, event);
  }
}
