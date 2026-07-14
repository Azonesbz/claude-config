// SessionStart hook: injects the methodology index into every session.
// Invoked in exec form (`node <this file>`), so it never goes through a shell —
// that keeps it identical on macOS, Linux and Windows, and avoids relying on the
// executable bit surviving a clone.

import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const INDEX_FILE = "methodology-index.md";

function readIndex() {
  const here = dirname(fileURLToPath(import.meta.url));
  return readFileSync(join(here, INDEX_FILE), "utf8");
}

function main() {
  // A hook that throws would surface a startup error on every session, so a
  // missing index degrades to "no extra context" rather than a broken session.
  let additionalContext;
  try {
    additionalContext = readIndex();
  } catch {
    process.exit(0);
  }

  process.stdout.write(
    JSON.stringify({
      hookSpecificOutput: {
        hookEventName: "SessionStart",
        additionalContext,
      },
    }),
  );
}

main();
