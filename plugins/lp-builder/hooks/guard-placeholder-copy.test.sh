#!/usr/bin/env bash
# AAA tests for guard-placeholder-copy.sh — filler copy written into a page file
# must be blocked; real copy must pass, and so must the files where lorem ipsum
# is legitimate (docs about this guard, fixtures, stories, seeds).
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${dir}/guard-placeholder-copy.sh"
fails=0

run_guard() { printf '%s' "$1" | "${guard}"; }
is_deny() { printf '%s' "$1" | grep -q '"permissionDecision":"deny"'; }

payload() {
  local file_path="$1" field="$2" text="$3"
  printf '{"tool_name":"Write","tool_input":{"file_path":"%s","%s":"%s"}}' \
    "${file_path}" "${field}" "${text}"
}

check_blocked() {
  # Arrange
  local label="$1" file_path="$2" field="$3" text="$4"
  local input; input="$(payload "${file_path}" "${field}" "${text}")"
  # Act
  local out; out="$(run_guard "${input}")"
  # Assert
  if is_deny "${out}"; then echo "PASS: blocked ${label}"; else
    echo "FAIL: expected block for ${label} (got: ${out})"; fails=$((fails + 1)); fi
}

check_allowed() {
  # Arrange
  local label="$1" file_path="$2" field="$3" text="$4"
  local input; input="$(payload "${file_path}" "${field}" "${text}")"
  # Act
  local out; out="$(run_guard "${input}")"
  # Assert
  if [ -z "${out}" ]; then echo "PASS: allowed ${label}"; else
    echo "FAIL: expected pass-through for ${label} (got: ${out})"; fails=$((fails + 1)); fi
}

# Filler in a page file — the case this guard exists for.
check_blocked "lorem ipsum in html"      "index.html"          "content"    "<p>Lorem ipsum dolor sit amet</p>"
check_blocked "lowercase in a component" "src/Hero.tsx"        "content"    "lorem ipsum dolor"
check_blocked "uppercase in jsx"         "src/Hero.jsx"        "content"    "LOREM IPSUM DOLOR"
check_blocked "filler in an Edit"        "src/Pricing.vue"     "new_string" "<h2>Lorem ipsum</h2>"
check_blocked "filler in astro"          "src/pages/index.astro" "content"  "Lorem  ipsum dolor"
check_blocked "filler in svelte"         "src/Hero.svelte"     "new_string" "<p>lorem ipsum</p>"

# Real copy in a page file — must never be blocked.
check_allowed "real hero copy"           "src/Hero.tsx"        "new_string" "<h1>Facture reglee en 48 heures</h1>"
check_allowed "explicit TODO placeholder" "src/Proof.tsx"      "new_string" "<p>TODO: temoignage client a fournir</p>"
check_allowed "the word lorem alone"     "src/Logos.tsx"       "new_string" "<p>Lorem Industries, notre client</p>"

# Files where lorem ipsum is legitimate — scoping keeps the guard out of the way.
check_allowed "docs describing the guard" "README.md"          "content"    "Le garde bloque le lorem ipsum"
check_allowed "python fixture"           "tests/fixtures.py"   "content"    "SAMPLE = 'lorem ipsum dolor'"
check_allowed "seed script"              "scripts/seed.ts"     "content"    "const body = 'lorem ipsum'"
check_allowed "component test file"      "src/Hero.test.tsx"   "content"    "render(<Hero body='lorem ipsum' />)"
check_allowed "storybook story"          "src/Hero.stories.tsx" "content"   "body: 'lorem ipsum dolor'"
check_allowed "file under __tests__"     "src/__tests__/hero.jsx" "content" "const copy = 'lorem ipsum'"
check_allowed "file under fixtures dir"  "src/fixtures/hero.html" "content" "<p>lorem ipsum</p>"

# No file_path (unknown tool shape) — cannot scope, so stay out of the way.
check_allowed "no file path"             ""                    "content"    "lorem ipsum dolor"

exit "${fails}"
