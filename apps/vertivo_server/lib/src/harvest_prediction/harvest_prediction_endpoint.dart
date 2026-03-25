import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class HarvestPredictionEndpoint extends Endpoint {
  /// Get harvest predictions for a greenhouse
  Future<List<HarvestPrediction>> getForGreenhouse(
    Session session,
    int greenhouseId, {
    int limit = 50,
  }) async {
    return await HarvestPrediction.db.find(
      session,
      where: (t) => t.greenhouseId.equals(greenhouseId),
      limit: limit,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get harvest predictions for a specific plant
  Future<List<HarvestPrediction>> getForPlant(
    Session session,
    int plantId,
  ) async {
    return await HarvestPrediction.db.find(
      session,
      where: (t) => t.plantId.equals(plantId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Create a harvest prediction
  Future<HarvestPrediction> create(
    Session session,
    HarvestPrediction prediction,
  ) async {
    prediction.createdAt = DateTime.now();
    return await HarvestPrediction.db.insertRow(session, prediction);
  }

  /// Record actual harvest results against a prediction
  Future<HarvestPrediction?> recordActual(
    Session session,
    int predictionId,
    double actualYieldKg,
    String actualQualityGrade,
  ) async {
    final prediction =
        await HarvestPrediction.db.findById(session, predictionId);
    if (prediction == null) return null;
    prediction.actualYieldKg = actualYieldKg;
    prediction.actualQualityGrade = actualQualityGrade;
    prediction.actualHarvestDate = DateTime.now();
    return await HarvestPrediction.db.updateRow(session, prediction);
  }

  /// Get quality prediction for a harvest prediction
  Future<QualityPrediction?> getQuality(
    Session session,
    int harvestPredictionId,
  ) async {
    final rows = await QualityPrediction.db.find(
      session,
      where: (t) => t.harvestPredictionId.equals(harvestPredictionId),
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  /// Create a quality prediction
  Future<QualityPrediction> createQuality(
    Session session,
    QualityPrediction quality,
  ) async {
    quality.createdAt = DateTime.now();
    return await QualityPrediction.db.insertRow(session, quality);
  }
}
