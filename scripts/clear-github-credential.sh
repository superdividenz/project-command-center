#!/bin/bash
# Clear stored GitHub credential so next 'git push' prompts for superdividenz.
# Run: bash scripts/clear-github-credential.sh
# Then: git push origin main (use superdividenz + Personal Access Token as password)

printf "host=github.com\nprotocol=https\n" | git credential-osxkeychain erase
echo "Done. Run: git push origin main (username: superdividenz, password: your PAT)"
