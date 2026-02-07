#!/usr/bin/env bash
# mock-evaluator.sh - Deterministic mock evaluator for testing
#
# Reads scores sequentially from a fixture file.
# Each invocation returns the next score in the list.
#
# Environment:
#   MOCK_SCORES_FILE - path to JSON fixture (default: tests/fixtures/eval-scores.json)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

MOCK_SCORES_FILE="${MOCK_SCORES_FILE:-$PROJECT_ROOT/tests/fixtures/eval-scores.json}"
CALL_COUNTER_FILE="${MOCK_CALL_COUNTER_FILE:-/tmp/mock-evaluator-call-count-$$}"

# Initialize counter if it doesn't exist
if [ ! -f "$CALL_COUNTER_FILE" ]; then
  echo "0" > "$CALL_COUNTER_FILE"
fi

# Read current call index
CALL_INDEX=$(cat "$CALL_COUNTER_FILE")

# Read the score at current index from fixture
SCORE=$(python3 -c "
import json
with open('$MOCK_SCORES_FILE', 'r') as f:
    data = json.load(f)
scores = data.get('scores', [50])
idx = $CALL_INDEX % len(scores)
print(scores[idx])
")

# Increment counter for next call
echo $(( CALL_INDEX + 1 )) > "$CALL_COUNTER_FILE"

# Output evaluation result as JSON
cat <<EOF
{"score": $SCORE, "reasoning": "mock evaluation #$((CALL_INDEX + 1))"}
EOF
