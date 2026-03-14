# lex-cognitive-palimpsest

Layered belief revision model for LegionIO cognitive agents. Like a manuscript where old text shows through, prior beliefs persist as ghosts when overwritten. Tracks version history, belief drift, ghost erosion, and restoration strength.

## What It Does

- Per-topic belief containers with versioned layers
- Overwrite creates a new layer and pushes the old one to history as a ghost
- Ghosts erode confidence over time via GHOST_DECAY
- `peek_through` reveals prior layers still showing through
- Track belief drift (confidence delta: original → current)
- Restoration strength: average ghost confidence (how much prior belief lingers)
- Domain archaeology: all palimpsests in a given domain
- Most-rewritten topics: subjects of the most belief revisions

## Usage

```ruby
# Create a palimpsest (topic with initial belief)
p = runner.create_palimpsest(topic: 'best_db_strategy', domain: :architecture,
                               content: 'relational DB for everything',
                               author: 'initial_analysis', confidence: 0.8)
pid = p[:palimpsest][:id]

# Revise the belief (old layer becomes a ghost)
runner.overwrite_belief(palimpsest_id: pid,
                         content: 'event store + read models for write-heavy',
                         author: 'after_load_testing', confidence: 0.75)

# See what's showing through from before
runner.peek_through_belief(palimpsest_id: pid, n: 3)
# => { success: true, layers: [{ content: 'relational DB...', confidence: 0.77, superseded_at: ... }] }

# Measure drift
runner.belief_drift(palimpsest_id: pid)
# => { success: true, drift: 0.05, label: :slight }

# Decay ghosts each tick
runner.decay_all_ghosts

# Status
runner.palimpsest_report
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
