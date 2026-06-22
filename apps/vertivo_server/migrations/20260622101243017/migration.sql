BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "crop_models" ADD COLUMN "idealPhIdeal" double precision;
ALTER TABLE "crop_models" ADD COLUMN "idealEcMinDsM" double precision;
ALTER TABLE "crop_models" ADD COLUMN "idealEcMaxDsM" double precision;
ALTER TABLE "crop_models" ADD COLUMN "idealNightTemperatureMin" double precision;
ALTER TABLE "crop_models" ADD COLUMN "idealNightTemperatureMax" double precision;
ALTER TABLE "crop_models" ADD COLUMN "idealOrpMinMv" double precision;
ALTER TABLE "crop_models" ADD COLUMN "idealOrpMaxMv" double precision;
ALTER TABLE "crop_models" ADD COLUMN "ppfdMin" double precision;
ALTER TABLE "crop_models" ADD COLUMN "ppfdMax" double precision;
ALTER TABLE "crop_models" ADD COLUMN "photoperiodHours" double precision;
ALTER TABLE "crop_models" ADD COLUMN "lightSpectrum" text;
ALTER TABLE "crop_models" ADD COLUMN "ediblePart" text;
ALTER TABLE "crop_models" ADD COLUMN "priority" bigint;
ALTER TABLE "crop_models" ADD COLUMN "aeroponicSuitable" boolean;
ALTER TABLE "crop_models" ADD COLUMN "profileKey" text;
ALTER TABLE "crop_models" ADD COLUMN "nutrientRecipeJson" text;

--
-- MIGRATION VERSION FOR vertivo
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vertivo', '20260622101243017', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260622101243017', "timestamp" = now();

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
