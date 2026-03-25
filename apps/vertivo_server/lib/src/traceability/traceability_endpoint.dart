import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TraceabilityEndpoint extends Endpoint {
  /// Add a traceability record with automatic hash chain
  Future<TraceabilityRecord> addRecord(
    Session session,
    TraceabilityRecord record,
  ) async {
    record.createdAt = DateTime.now();
    record.isVerified = false;

    // Get the last record in this batch's chain
    final lastRecords = await TraceabilityRecord.db.find(
      session,
      where: (t) => t.batchId.equals(record.batchId),
      orderBy: (t) => t.sequenceNumber,
      orderDescending: true,
      limit: 1,
    );

    if (lastRecords.isEmpty) {
      // Genesis record
      record.sequenceNumber = 1;
      record.previousHash = '0';
    } else {
      final last = lastRecords.first;
      record.sequenceNumber = last.sequenceNumber + 1;
      record.previousHash = last.recordHash;
    }

    // Compute SHA256 hash of this record's content
    record.recordHash = _computeHash(record);

    return await TraceabilityRecord.db.insertRow(session, record);
  }

  /// Get the full traceability chain for a batch
  Future<List<TraceabilityRecord>> getChain(
    Session session,
    String batchId,
  ) async {
    return await TraceabilityRecord.db.find(
      session,
      where: (t) => t.batchId.equals(batchId),
      orderBy: (t) => t.sequenceNumber,
    );
  }

  /// Verify the integrity of a batch's hash chain
  Future<bool> verifyChain(Session session, String batchId) async {
    final chain = await getChain(session, batchId);
    if (chain.isEmpty) return true;

    // Verify genesis record
    if (chain.first.previousHash != '0') return false;

    for (var i = 0; i < chain.length; i++) {
      final record = chain[i];

      // Verify hash integrity
      final expectedHash = _computeHash(record);
      if (record.recordHash != expectedHash) return false;

      // Verify chain linkage (skip genesis)
      if (i > 0 && record.previousHash != chain[i - 1].recordHash) {
        return false;
      }
    }
    return true;
  }

  /// Generate a compliance report for a greenhouse against a template
  Future<ComplianceReport> generateReport(
    Session session,
    int greenhouseId,
    int templateId, {
    String? batchId,
  }) async {
    final template = await ComplianceTemplate.db.findById(session, templateId);
    if (template == null) {
      throw Exception('Compliance template not found');
    }

    // Get traceability records for this greenhouse/batch
    final records = await TraceabilityRecord.db.find(
      session,
      where: batchId != null
          ? (t) =>
              t.greenhouseId.equals(greenhouseId) &
              t.batchId.equals(batchId)
          : (t) => t.greenhouseId.equals(greenhouseId),
    );

    // Check which required event types are present
    final presentEventTypes = records.map((r) => r.eventType).toSet();
    final requiredTypes = template.requiredEventTypes;
    var passedChecks = 0;
    for (final required in requiredTypes) {
      if (presentEventTypes.contains(required)) passedChecks++;
    }
    final totalChecks = requiredTypes.length;
    final failedChecks = totalChecks - passedChecks;
    final score = totalChecks > 0 ? (passedChecks / totalChecks) * 100 : 0.0;
    final status = failedChecks == 0 ? 'compliant' : 'non_compliant';

    final report = ComplianceReport(
      greenhouseId: greenhouseId,
      batchId: batchId,
      templateId: templateId,
      standardCode: template.standardCode,
      status: status,
      overallScore: score,
      totalChecks: totalChecks,
      passedChecks: passedChecks,
      failedChecks: failedChecks,
      createdAt: DateTime.now(),
    );

    return await ComplianceReport.db.insertRow(session, report);
  }

  /// Get compliance reports for a greenhouse
  Future<List<ComplianceReport>> getReports(
    Session session,
    int greenhouseId, {
    int limit = 50,
  }) async {
    return await ComplianceReport.db.find(
      session,
      where: (t) => t.greenhouseId.equals(greenhouseId),
      limit: limit,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get available compliance templates
  Future<List<ComplianceTemplate>> getTemplates(Session session) async {
    return await ComplianceTemplate.db.find(
      session,
      where: (t) => t.isActive.equals(true),
    );
  }

  String _computeHash(TraceabilityRecord record) {
    final content =
        '${record.batchId}|${record.eventType}|${record.description}|'
        '${record.sequenceNumber}|${record.previousHash}|'
        '${record.createdAt.toIso8601String()}';
    return sha256.convert(utf8.encode(content)).toString();
  }
}
