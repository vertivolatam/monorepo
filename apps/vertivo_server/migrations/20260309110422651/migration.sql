BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "alert_templates" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "alertType" text NOT NULL,
    "severity" text NOT NULL,
    "titleTemplate" text NOT NULL,
    "messageTemplate" text NOT NULL,
    "segmentTarget" text NOT NULL,
    "channels" json NOT NULL,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "alerts" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "greenhouseId" bigint,
    "plantId" bigint,
    "trayId" bigint,
    "alertType" text NOT NULL,
    "severity" text NOT NULL,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "sourceEntityType" text,
    "sourceEntityId" bigint,
    "isRead" boolean NOT NULL,
    "isAcknowledged" boolean NOT NULL,
    "acknowledgedAt" timestamp without time zone,
    "acknowledgedBy" text,
    "isResolved" boolean NOT NULL,
    "resolvedAt" timestamp without time zone,
    "escalationLevel" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "anomalies" (
    "id" bigserial PRIMARY KEY,
    "greenhouseId" bigint NOT NULL,
    "plantId" bigint,
    "trayId" bigint,
    "anomalyType" text NOT NULL,
    "severity" text NOT NULL,
    "detectionMethod" text NOT NULL,
    "measurementType" text,
    "expectedValue" double precision,
    "actualValue" double precision,
    "deviationPercent" double precision,
    "description" text NOT NULL,
    "isResolved" boolean NOT NULL,
    "resolvedAt" timestamp without time zone,
    "resolvedBy" text,
    "resolutionNotes" text,
    "sourceEntityType" text,
    "sourceEntityId" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "api_tokens" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "name" text NOT NULL,
    "token" text NOT NULL,
    "scopes" json NOT NULL,
    "isActive" boolean NOT NULL,
    "lastUsedAt" timestamp without time zone,
    "expiresAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "compliance_reports" (
    "id" bigserial PRIMARY KEY,
    "greenhouseId" bigint NOT NULL,
    "batchId" text,
    "templateId" bigint NOT NULL,
    "standardCode" text NOT NULL,
    "status" text NOT NULL,
    "overallScore" double precision,
    "totalChecks" bigint NOT NULL,
    "passedChecks" bigint NOT NULL,
    "failedChecks" bigint NOT NULL,
    "findings" text,
    "recommendations" text,
    "reportedBy" text,
    "reviewedBy" text,
    "reviewedAt" timestamp without time zone,
    "validUntil" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "compliance_templates" (
    "id" bigserial PRIMARY KEY,
    "standardCode" text NOT NULL,
    "standardName" text NOT NULL,
    "version" text NOT NULL,
    "region" text NOT NULL,
    "category" text NOT NULL,
    "requiredEventTypes" json NOT NULL,
    "requiredDocuments" json,
    "validationRules" text,
    "isActive" boolean NOT NULL,
    "effectiveFrom" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crop_models" (
    "id" bigserial PRIMARY KEY,
    "species" text NOT NULL,
    "commonName" text NOT NULL,
    "scientificName" text,
    "family" text,
    "category" text NOT NULL,
    "idealTemperatureMin" double precision NOT NULL,
    "idealTemperatureMax" double precision NOT NULL,
    "idealHumidityMin" double precision NOT NULL,
    "idealHumidityMax" double precision NOT NULL,
    "idealLightHoursMin" double precision NOT NULL,
    "idealLightHoursMax" double precision NOT NULL,
    "idealPhMin" double precision NOT NULL,
    "idealPhMax" double precision NOT NULL,
    "idealCo2Min" double precision,
    "idealCo2Max" double precision,
    "waterRequirement" text NOT NULL,
    "growthDurationDays" bigint NOT NULL,
    "commonDiseases" json,
    "commonPests" json,
    "companionPlants" json,
    "incompatiblePlants" json,
    "difficulty" text NOT NULL,
    "segments" json NOT NULL,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "disease_detections" (
    "id" bigserial PRIMARY KEY,
    "plantId" bigint NOT NULL,
    "greenhouseId" bigint NOT NULL,
    "diseaseType" text NOT NULL,
    "diseaseName" text NOT NULL,
    "confidence" double precision NOT NULL,
    "severity" text NOT NULL,
    "affectedAreaPercent" double precision,
    "anatomicalParts" json,
    "imageUrl" text,
    "aiModelVersion" text,
    "isConfirmed" boolean NOT NULL,
    "confirmedBy" text,
    "notes" text,
    "detectedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "environmental_readings" (
    "id" bigserial PRIMARY KEY,
    "greenhouseId" bigint NOT NULL,
    "measurementType" text NOT NULL,
    "value" double precision NOT NULL,
    "unit" text NOT NULL,
    "source" text,
    "isAnomaly" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "escalation_rules" (
    "id" bigserial PRIMARY KEY,
    "alertType" text NOT NULL,
    "severity" text NOT NULL,
    "escalationLevel" bigint NOT NULL,
    "delayMinutes" bigint NOT NULL,
    "notifyChannels" json NOT NULL,
    "notifyRoles" json,
    "autoResolveAfterMinutes" bigint,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "greenhouses" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "location" text,
    "latitude" double precision,
    "longitude" double precision,
    "climateType" text,
    "irrigationType" text NOT NULL,
    "totalTrays" bigint NOT NULL,
    "isActive" boolean NOT NULL,
    "temperatureMin" double precision,
    "temperatureMax" double precision,
    "humidityMin" double precision,
    "humidityMax" double precision,
    "lightMin" double precision,
    "lightMax" double precision,
    "co2Min" double precision,
    "co2Max" double precision,
    "phMin" double precision,
    "phMax" double precision,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "growth_stage_definitions" (
    "id" bigserial PRIMARY KEY,
    "cropModelId" bigint NOT NULL,
    "stageName" text NOT NULL,
    "stageOrder" bigint NOT NULL,
    "durationDaysMin" bigint NOT NULL,
    "durationDaysMax" bigint NOT NULL,
    "description" text,
    "careInstructions" text,
    "expectedHeightMinCm" double precision,
    "expectedHeightMaxCm" double precision,
    "expectedLeafCountMin" bigint,
    "expectedLeafCountMax" bigint,
    "temperatureMinOverride" double precision,
    "temperatureMaxOverride" double precision,
    "humidityMinOverride" double precision,
    "humidityMaxOverride" double precision,
    "lightHoursMinOverride" double precision,
    "lightHoursMaxOverride" double precision,
    "wateringFrequencyDays" bigint,
    "fertilizerType" text,
    "keyIndicators" json,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "harvest_predictions" (
    "id" bigserial PRIMARY KEY,
    "greenhouseId" bigint NOT NULL,
    "plantId" bigint,
    "cropSpecies" text NOT NULL,
    "predictedYieldKg" double precision NOT NULL,
    "yieldConfidence" double precision NOT NULL,
    "qualityGrade" text NOT NULL,
    "harvestWindowStart" timestamp without time zone NOT NULL,
    "harvestWindowEnd" timestamp without time zone NOT NULL,
    "daysToHarvest" bigint NOT NULL,
    "scenarioType" text NOT NULL,
    "actualYieldKg" double precision,
    "actualQualityGrade" text,
    "actualHarvestDate" timestamp without time zone,
    "modelVersion" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "irrigation_events" (
    "id" bigserial PRIMARY KEY,
    "greenhouseId" bigint NOT NULL,
    "trayId" bigint,
    "irrigationType" text NOT NULL,
    "durationMinutes" double precision NOT NULL,
    "waterVolumeLiters" double precision,
    "nutrientMix" text,
    "triggeredBy" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "kpi_metrics" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "greenhouseId" bigint,
    "metricType" text NOT NULL,
    "value" double precision NOT NULL,
    "unit" text,
    "periodStart" timestamp without time zone NOT NULL,
    "periodEnd" timestamp without time zone NOT NULL,
    "periodType" text NOT NULL,
    "previousValue" double precision,
    "changePercent" double precision,
    "targetValue" double precision,
    "segment" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_deliveries" (
    "id" bigserial PRIMARY KEY,
    "alertId" bigint NOT NULL,
    "userId" text NOT NULL,
    "channel" text NOT NULL,
    "status" text NOT NULL,
    "sentAt" timestamp without time zone,
    "deliveredAt" timestamp without time zone,
    "readAt" timestamp without time zone,
    "failureReason" text,
    "retryCount" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "nutritional_deficiencies" (
    "id" bigserial PRIMARY KEY,
    "plantId" bigint NOT NULL,
    "greenhouseId" bigint NOT NULL,
    "nutrient" text NOT NULL,
    "severity" text NOT NULL,
    "symptoms" json,
    "confidence" double precision NOT NULL,
    "recommendedAction" text,
    "isResolved" boolean NOT NULL,
    "resolvedAt" timestamp without time zone,
    "detectedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pest_identifications" (
    "id" bigserial PRIMARY KEY,
    "plantId" bigint NOT NULL,
    "greenhouseId" bigint NOT NULL,
    "pestType" text NOT NULL,
    "confidence" double precision NOT NULL,
    "infestationLevel" text NOT NULL,
    "affectedPlantCount" bigint,
    "imageUrl" text,
    "aiModelVersion" text,
    "isConfirmed" boolean NOT NULL,
    "confirmedBy" text,
    "detectedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "plants" (
    "id" bigserial PRIMARY KEY,
    "trayId" bigint NOT NULL,
    "greenhouseId" bigint NOT NULL,
    "position" bigint NOT NULL,
    "species" text NOT NULL,
    "variety" text,
    "growthStage" text NOT NULL,
    "healthScore" double precision NOT NULL,
    "isQuarantined" boolean NOT NULL,
    "quarantineReason" text,
    "plantedAt" timestamp without time zone NOT NULL,
    "lastInspectedAt" timestamp without time zone,
    "estimatedHarvestDate" timestamp without time zone,
    "height" double precision,
    "leafCount" bigint,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "quality_predictions" (
    "id" bigserial PRIMARY KEY,
    "harvestPredictionId" bigint NOT NULL,
    "plantId" bigint,
    "greenhouseId" bigint NOT NULL,
    "vitaminAScore" double precision,
    "vitaminCScore" double precision,
    "vitaminKScore" double precision,
    "ironScore" double precision,
    "calciumScore" double precision,
    "potassiumScore" double precision,
    "overallNutritionalScore" double precision NOT NULL,
    "appearanceColorScore" double precision,
    "appearanceSizeScore" double precision,
    "appearanceUniformityScore" double precision,
    "overallAppearanceScore" double precision NOT NULL,
    "shelfLifeDays" bigint,
    "modelVersion" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "security_events" (
    "id" bigserial PRIMARY KEY,
    "userId" text,
    "eventType" text NOT NULL,
    "severity" text NOT NULL,
    "ipAddress" text,
    "deviceId" text,
    "details" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "subscription_plans" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "planType" text NOT NULL,
    "segment" text NOT NULL,
    "isActive" boolean NOT NULL,
    "features" json NOT NULL,
    "maxGreenhouses" bigint NOT NULL,
    "monthlyPriceUsd" double precision NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "traceability_records" (
    "id" bigserial PRIMARY KEY,
    "greenhouseId" bigint NOT NULL,
    "batchId" text NOT NULL,
    "eventType" text NOT NULL,
    "description" text NOT NULL,
    "performedBy" text,
    "metadata" text,
    "recordHash" text NOT NULL,
    "previousHash" text NOT NULL,
    "sequenceNumber" bigint NOT NULL,
    "isVerified" boolean NOT NULL,
    "verifiedAt" timestamp without time zone,
    "verifiedBy" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "trays" (
    "id" bigserial PRIMARY KEY,
    "greenhouseId" bigint NOT NULL,
    "position" bigint NOT NULL,
    "label" text,
    "cropType" text,
    "plantingDate" timestamp without time zone,
    "expectedHarvestDate" timestamp without time zone,
    "status" text NOT NULL,
    "plantCount" bigint NOT NULL,
    "healthScore" double precision,
    "soilPh" double precision,
    "soilMoisture" double precision,
    "soilFertility" text,
    "lastIrrigatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "treatment_recommendations" (
    "id" bigserial PRIMARY KEY,
    "diseaseDetectionId" bigint,
    "pestIdentificationId" bigint,
    "plantId" bigint NOT NULL,
    "treatmentType" text NOT NULL,
    "description" text NOT NULL,
    "ingredients" json,
    "applicationMethod" text,
    "frequencyDays" bigint,
    "durationDays" bigint,
    "estimatedCost" double precision,
    "segmentTarget" text NOT NULL,
    "priority" text NOT NULL,
    "isApplied" boolean NOT NULL,
    "appliedAt" timestamp without time zone,
    "effectivenessScore" double precision,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_preferences" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "notificationEmail" boolean NOT NULL,
    "notificationPush" boolean NOT NULL,
    "notificationSms" boolean NOT NULL,
    "notificationWhatsapp" boolean NOT NULL,
    "displayLanguage" text NOT NULL,
    "displayTimezone" text NOT NULL,
    "displayTemperatureUnit" text NOT NULL,
    "privacyShareData" boolean NOT NULL,
    "privacyAnalytics" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_profiles" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "segment" text NOT NULL,
    "familySize" bigint,
    "dietaryPreferences" json,
    "gardeningExperience" text,
    "businessType" text,
    "businessName" text,
    "qualityRequirements" text,
    "supplyChainGoals" text,
    "complianceRequirements" json,
    "sustainabilityGoals" text,
    "erpIntegration" text,
    "certifications" json,
    "capabilities" json,
    "workSchedule" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_sessions" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "deviceId" text NOT NULL,
    "deviceName" text,
    "deviceType" text,
    "ipAddress" text,
    "userAgent" text,
    "accessToken" text NOT NULL,
    "refreshToken" text NOT NULL,
    "securityLevel" text NOT NULL,
    "isActive" boolean NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "lastActivityAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "users" (
    "id" bigserial PRIMARY KEY,
    "authIdentifier" text NOT NULL,
    "email" text NOT NULL,
    "displayName" text NOT NULL,
    "segment" text NOT NULL,
    "isActive" boolean NOT NULL,
    "isEmailVerified" boolean NOT NULL,
    "passwordHash" text NOT NULL,
    "twoFactorEnabled" boolean NOT NULL,
    "twoFactorSecret" text,
    "lastLoginAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR vertivo
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vertivo', '20260309110422651', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260309110422651', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
