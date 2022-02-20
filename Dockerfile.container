FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY app/pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY app/bin bin
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/main.dart -o bin/main

# Build minimal serving image from AOT-compiled `/main` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/main /app/bin/

ENTRYPOINT ["/app/bin/main"]
