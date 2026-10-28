// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_hubspot/otel_hubspot.dart';

/// Traces HubSpot CRM calls with OpenTelemetry.
///
/// `otel_hubspot` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each HubSpot CRM call in
/// [tracedHubspot]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'hubspot-example');

  // Wraps a HubSpot CRM API call in a CLIENT span.
  final hubspotId = await tracedHubspot<String>(
    objectType: 'standard',
    action: 'example',
    objectId: 'object_8f3a2c',
    portalId: 'portal_8f3a2c',
    invoke: () async {
      // Make the HubSpot CRM call here, then report what it returned.
      return 'hubspot_8f3a2c';
    },
  );
  OTelLog.info('tracedHubspot returned $hubspotId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutHubspotInstrumentationAsync.
  await runWithoutHubspotInstrumentationAsync(
    () => tracedHubspot<String>(
      objectType: 'standard',
      action: 'example',
      objectId: 'object_8f3a2c',
      portalId: 'portal_8f3a2c',
      invoke: () async {
        return 'hubspot_8f3a2c';
      },
    ),
  );

  await OTel.shutdown();
}
