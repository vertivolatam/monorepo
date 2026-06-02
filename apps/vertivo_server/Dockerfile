# Build stage
#
# The build context is the MONOREPO ROOT (see
# infrastructure/scripts/build-backend-image-minikube.sh), not apps/vertivo_server.
# This is required because apps/vertivo_server/pubspec.yaml declares
# `resolution: workspace`, so `dart pub get` needs a Dart pub-workspace root that
# lists the server as a member. Without it pub fails with:
#   "has resolution `workspace` but found no workspace root" (exit 66).
#
# We build a MINIMAL workspace root that lists only `apps/vertivo_server`. The
# real monorepo root also includes Flutter members (vertivo_flutter) whose
# dependencies require the Flutter SDK, which is not present in the dart image.
# The server itself has no Flutter/path dependencies, so a server-only workspace
# resolves with a pure Dart toolchain.
#
# We copy the committed monorepo pubspec.lock so the build uses the exact, known
# good dependency versions. This is load-bearing: a fresh resolution picks
# relic_core 1.2.0, which collides with serverpod 3.4.1's `Cache` symbol and
# breaks AOT compilation. The lock pins relic_core 1.1.1.
# The lockfile requires Dart >= 3.10.3, hence dart:3.11 (was dart:3.8.0).
FROM dart:3.11 AS build
WORKDIR /app

# 1. Workspace resolution layer (cached unless deps change).
#    Minimal workspace root + server pubspec + committed lockfile.
COPY apps/vertivo_server/pubspec.yaml apps/vertivo_server/pubspec.yaml
COPY pubspec.lock pubspec.lock
RUN printf 'name: vertivo_workspace\npublish_to: none\nenvironment:\n  sdk: "^3.8.0"\nworkspace:\n  - apps/vertivo_server\n' > pubspec.yaml

# Resolve from the member dir. We do NOT use --enforce-lockfile: the committed
# pubspec.lock is for the FULL workspace (including Flutter members), so it
# contains entries this server-only workspace doesn't have, which pub refuses to
# "enforce". Plain `pub get` still honours the locked versions for packages it
# does use (notably relic_core 1.1.1, the version compatible with serverpod
# 3.4.1), which is what we need to avoid the `Cache` symbol collision at compile.
RUN dart pub get -C apps/vertivo_server

# 2. Source layer: copy the server code and compile the executable.
COPY apps/vertivo_server apps/vertivo_server
WORKDIR /app/apps/vertivo_server
RUN dart compile exe bin/main.dart -o bin/server

# Final stage
FROM alpine:latest

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable
COPY --from=build /app/apps/vertivo_server/bin/server server

# Copy configuration files and resources
COPY --from=build /app/apps/vertivo_server/config/ config/
COPY --from=build /app/apps/vertivo_server/web/ web/
COPY --from=build /app/apps/vertivo_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/apps/vertivo_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role
