import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class CropCatalogEndpoint extends Endpoint {
  /// List all active crops in the catalog
  Future<List<CropModel>> list(
    Session session, {
    int limit = 100,
    int offset = 0,
  }) async {
    return await CropModel.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.commonName,
    );
  }

  /// Get a crop by id
  Future<CropModel?> get(Session session, int id) async {
    return await CropModel.db.findById(session, id);
  }

  /// Search crops by species or common name
  Future<List<CropModel>> search(Session session, String query) async {
    return await CropModel.db.find(
      session,
      where: (t) =>
          t.isActive.equals(true) &
          (t.commonName.like('%$query%') | t.species.like('%$query%')),
    );
  }

  /// Create a crop in the catalog
  Future<CropModel> create(Session session, CropModel crop) async {
    crop.createdAt = DateTime.now();
    crop.updatedAt = DateTime.now();
    crop.isActive = true;
    return await CropModel.db.insertRow(session, crop);
  }

  /// Update a crop model
  Future<CropModel> update(Session session, CropModel crop) async {
    crop.updatedAt = DateTime.now();
    return await CropModel.db.updateRow(session, crop);
  }

  /// Get growth stage definitions for a crop
  Future<List<GrowthStageDefinition>> getGrowthStages(
    Session session,
    int cropModelId,
  ) async {
    return await GrowthStageDefinition.db.find(
      session,
      where: (t) => t.cropModelId.equals(cropModelId),
      orderBy: (t) => t.stageOrder,
    );
  }

  /// Create a growth stage definition
  Future<GrowthStageDefinition> createGrowthStage(
    Session session,
    GrowthStageDefinition stage,
  ) async {
    stage.createdAt = DateTime.now();
    return await GrowthStageDefinition.db.insertRow(session, stage);
  }
}
