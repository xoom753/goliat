# Activity renderers

This page describes the renderer family that adapts current and historical activities to a shared report interface.

## Class hierarchy

- [`GenericActivityRenderer`](../app/services/person_ejes_resumen/activity_renderer_service/generic_activity_renderer.rb) is the abstract base. It exposes the source end date and parses durations into hours.
- [`LegacyActivityRenderer`](../app/services/person_ejes_resumen/activity_renderer_service/legacy_activity_renderer.rb) adapts historical activity records, using the legacy activity name and duration.
- [`PresentActivityRenderer`](../app/services/person_ejes_resumen/activity_renderer_service/present_activity_renderer.rb) adapts current person activities, using the coursable name, optional human name, quantity, month, and year.

Both concrete renderers inherit `GenericActivityRenderer` and provide the same report-facing methods: `activity_nombre`, `activity_human_name_d`, `duracion_i`, and `month`.

## Where they are used

`PersonEjesResumen::ActivitiesGroupService::GroupedActivitiesRenderer` wraps current and historical records with their respective renderer, sorts them by end date, and groups similar activities for report periods.

## Adding a renderer

When adding another activity source, subclass `GenericActivityRenderer`, implement the report-facing methods for that source, and add the class to this family guide.
