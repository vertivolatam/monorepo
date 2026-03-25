import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PhytopathologyEndpoint extends Endpoint {
  /// Record a disease detection
  Future<DiseaseDetection> recordDiseaseDetection(
    Session session,
    DiseaseDetection detection,
  ) async {
    detection.createdAt = DateTime.now();
    detection.detectedAt = DateTime.now();
    detection.isConfirmed = false;
    return await DiseaseDetection.db.insertRow(session, detection);
  }

  /// Get disease detections for a plant
  Future<List<DiseaseDetection>> getDetectionsForPlant(
    Session session,
    int plantId,
  ) async {
    return await DiseaseDetection.db.find(
      session,
      where: (t) => t.plantId.equals(plantId),
      orderBy: (t) => t.detectedAt,
      orderDescending: true,
    );
  }

  /// Get disease detections for a greenhouse
  Future<List<DiseaseDetection>> getDetectionsForGreenhouse(
    Session session,
    int greenhouseId, {
    int limit = 50,
  }) async {
    return await DiseaseDetection.db.find(
      session,
      where: (t) => t.greenhouseId.equals(greenhouseId),
      limit: limit,
      orderBy: (t) => t.detectedAt,
      orderDescending: true,
    );
  }

  /// Confirm a disease detection
  Future<DiseaseDetection?> confirmDetection(
    Session session,
    int detectionId,
    String confirmedBy,
  ) async {
    final detection = await DiseaseDetection.db.findById(session, detectionId);
    if (detection == null) return null;
    detection.isConfirmed = true;
    detection.confirmedBy = confirmedBy;
    return await DiseaseDetection.db.updateRow(session, detection);
  }

  /// Record a pest identification
  Future<PestIdentification> recordPestIdentification(
    Session session,
    PestIdentification identification,
  ) async {
    identification.createdAt = DateTime.now();
    identification.detectedAt = DateTime.now();
    identification.isConfirmed = false;
    return await PestIdentification.db.insertRow(session, identification);
  }

  /// Get pest identifications for a greenhouse
  Future<List<PestIdentification>> getPestsForGreenhouse(
    Session session,
    int greenhouseId, {
    int limit = 50,
  }) async {
    return await PestIdentification.db.find(
      session,
      where: (t) => t.greenhouseId.equals(greenhouseId),
      limit: limit,
      orderBy: (t) => t.detectedAt,
      orderDescending: true,
    );
  }

  /// Record a nutritional deficiency
  Future<NutritionalDeficiency> recordDeficiency(
    Session session,
    NutritionalDeficiency deficiency,
  ) async {
    deficiency.createdAt = DateTime.now();
    deficiency.detectedAt = DateTime.now();
    deficiency.isResolved = false;
    return await NutritionalDeficiency.db.insertRow(session, deficiency);
  }

  /// Get treatment recommendations for a plant
  Future<List<TreatmentRecommendation>> getTreatments(
    Session session,
    int plantId,
  ) async {
    return await TreatmentRecommendation.db.find(
      session,
      where: (t) => t.plantId.equals(plantId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Create a treatment recommendation
  Future<TreatmentRecommendation> createTreatment(
    Session session,
    TreatmentRecommendation treatment,
  ) async {
    treatment.createdAt = DateTime.now();
    treatment.isApplied = false;
    return await TreatmentRecommendation.db.insertRow(session, treatment);
  }

  /// Mark a treatment as applied and score effectiveness
  Future<TreatmentRecommendation?> markTreatmentApplied(
    Session session,
    int treatmentId,
    double? effectivenessScore,
  ) async {
    final treatment =
        await TreatmentRecommendation.db.findById(session, treatmentId);
    if (treatment == null) return null;
    treatment.isApplied = true;
    treatment.appliedAt = DateTime.now();
    treatment.effectivenessScore = effectivenessScore;
    return await TreatmentRecommendation.db.updateRow(session, treatment);
  }
}
