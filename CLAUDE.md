# lex-cognitive-palimpsest

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`

## Purpose

Layered belief revision model based on the palimpsest (a manuscript where old text shows through new text). Each topic has a `Palimpsest` with a current `BeliefLayer` and historical layers (ghosts). When a belief is overwritten, the old layer is superseded and pushed to history where it becomes a ghost — still visible, still eroding, but no longer active. Tracks belief drift (how far the current belief has moved from the original) and restoration strength (how much ghost evidence remains). Models how prior beliefs persist in cognitive memory even after revision.

## Gem Info

- **Gem name**: `lex-cognitive-palimpsest`
- **Module**: `Legion::Extensions::CognitivePalimpsest`
- **Version**: `0.1.0`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_palimpsest/
  version.rb
  client.rb
  helpers/
    constants.rb
    belief_layer.rb
    palimpsest.rb
  runners/
    cognitive_palimpsest.rb
```

## Key Constants

| Constant | Value | Purpose |
|---|---|---|
| `MAX_PALIMPSESTS` | `200` | Per-engine topic capacity |
| `MAX_LAYERS_PER_TOPIC` | `20` | Historical layer cap per palimpsest |
| `DEFAULT_CONFIDENCE` | `0.7` | Starting confidence for new layers |
| `GHOST_THRESHOLD` | `0.1` | Confidence below which a layer becomes a ghost |
| `EROSION_RATE` | `0.05` | Current layer confidence decay per `erode_current!` call |
| `GHOST_DECAY` | `0.02` | Per-cycle confidence decay for ghost (historical) layers |
| `LAYER_DOMAINS` | symbol array | Valid domain categories |
| `CONFIDENCE_LABELS` | range hash | From `:dismissed` to `:certain` |
| `GHOST_LABELS` | range hash | Ghost layer state labels |
| `DRIFT_LABELS` | range hash | Belief drift magnitude labels |

## Helpers

### `Helpers::BeliefLayer`
Individual belief layer. Has `id`, `content`, `author`, `domain`, `version`, `confidence`, `created_at`, and `superseded_at`.

- `supersede!` — sets `superseded_at`, marks as historical
- `superseded?` — returns true after supersession
- `ghost?` — confidence below `GHOST_THRESHOLD`
- `dissipated?` — confidence at or near zero (fully faded)
- `erode!` — reduces confidence by `EROSION_RATE` (for current layer)
- `confidence_label` / `ghost_label`

### `Helpers::Palimpsest`
Topic-keyed belief container. Has `id`, `topic`, `domain`, `current_layer`, and `historical_layers` array.

- `overwrite!(content:, author:, confidence:)` — supersedes current layer, pushes to historical, creates new current layer with incremented version; enforces `MAX_LAYERS_PER_TOPIC`
- `peek_through(n)` — returns last N historical layers (the "showing through" prior beliefs)
- `erode_current!` — applies `EROSION_RATE` to current layer confidence
- `ghost_layers` → historical layers that qualify as ghosts
- `all_layers` → current + all historical
- `restoration_strength` — average confidence across all ghost layers (how much prior belief remains)
- `belief_drift` — absolute confidence delta between first historical layer and current
- `drift_label`
- `decay_ghosts!` — applies `GHOST_DECAY` to all historical layers; removes dissipated ones

## Runners

Module: `Runners::CognitivePalimpsest`

| Runner Method | Description |
|---|---|
| `create_palimpsest(topic:, domain:, content:, author:, confidence:)` | Create a topic with initial belief |
| `overwrite_belief(palimpsest_id:, content:, author:, confidence:)` | Revise the current belief |
| `peek_through_belief(palimpsest_id:, n:)` | View prior layers showing through |
| `erode_belief(palimpsest_id:)` | Erode current layer confidence |
| `ghost_layers(palimpsest_id:)` | Ghost layers for a topic |
| `all_ghost_layers` | All ghost layers across all topics |
| `domain_archaeology(domain:)` | All palimpsests in a domain |
| `belief_drift(palimpsest_id:)` | Drift from original to current |
| `overwrite_frequency(palimpsest_id:)` | Number of revisions |
| `most_rewritten(limit:)` | Topics with most revisions |
| `decay_all_ghosts` | Apply ghost decay to all topics |
| `palimpsest_report` | Aggregate stats |

All runners return `{success: true/false, ...}` hashes.

## Integration Points

- `lex-memory`: palimpsest layers are richer than memory traces — they have version, author, and drift tracking
- `lex-dream` contradiction_resolution phase: `peek_through_belief` reveals prior layers that may contradict the current one
- `lex-identity`: belief drift in identity-related topics can feed entropy divergence detection
- `lex-coldstart`: initial beliefs (imprint window) should have high confidence; later overwriting shows drift from firmware

## Development Notes

- `Client` instantiates `@palimpsest_engine = Helpers::PalimpsestEngine.new`
- `overwrite!` enforces `MAX_LAYERS_PER_TOPIC = 20` by dropping the oldest historical layer when at capacity
- `peek_through(n)` is an archaeological operation — it does not modify state
- `decay_ghosts!` removes layers where `dissipated?` returns true — permanent loss of very old beliefs
- `restoration_strength` is near-zero when all ghosts have faded — the topic has been fully revised
