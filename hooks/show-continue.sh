#!/bin/bash
# Show continue command on Claude exit

# Read JSON from stdin and extract session_id
SESSION_ID=$(jq -r '.session_id // empty' 2>/dev/null)

if [[ -n "$SESSION_ID" ]]; then
    echo ""
    echo "To continue this session:"
    echo "  claude -c $SESSION_ID"
fi
