#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

cd "$repo_root"

render_scenario() {
  local name="$1"
  local data="$2"
  local dir="$tmpdir/$name"

  mkdir -p "$dir"

  chezmoi execute-template --override-data "$data" --file AGENTS.md.tmpl > "$dir/home-AGENTS.md"
  chezmoi execute-template --override-data "$data" --file CLAUDE.md.tmpl > "$dir/home-CLAUDE.md"
  chezmoi execute-template --override-data "$data" --file dot_codex/AGENTS.md.tmpl > "$dir/codex-AGENTS.md"
  chezmoi execute-template --override-data "$data" --file dot_claude/CLAUDE.md.tmpl > "$dir/claude-CLAUDE.md"

  for rendered in "$dir"/*.md; do
    test -s "$rendered"
    grep -q "Public Content Boundary" "$rendered"
    grep -q "confidentiality-guardian.md" "$rendered"
    grep -q "W2 work, consulting work" "$rendered"
    if grep -q "{{\\|}}" "$rendered"; then
      echo "Template directive leaked in $rendered" >&2
      return 1
    fi
    if grep -q "## Skill Loading" "$rendered"; then
      echo "Full public-content profile leaked into root file $rendered" >&2
      return 1
    fi
  done

  for rendered in "$dir"/*AGENTS.md; do
    grep -q "## Codex-Specific Rules" "$rendered"
    if grep -Eq "## Claude-Specific Rules|Promotion Tracking" "$rendered"; then
      echo "Claude-only rules leaked into Codex file $rendered" >&2
      return 1
    fi
  done

  for rendered in "$dir"/*CLAUDE.md; do
    grep -q "## Claude-Specific Rules" "$rendered"
    if grep -Eq "## Codex-Specific Rules|github-cli-sandbox" "$rendered"; then
      echo "Codex-only rules leaked into Claude file $rendered" >&2
      return 1
    fi
  done

  if [[ "$name" == "work" ]]; then
    grep -q "Promotion Tracking" "$dir/home-CLAUDE.md"
    grep -q "Promotion Tracking" "$dir/claude-CLAUDE.md"
  else
    if grep -q "Promotion Tracking" "$dir"/*CLAUDE.md; then
      echo "Work-only promotion rules leaked into non-work Claude files" >&2
      return 1
    fi
  fi
}

render_scenario "personal" '{"purpose":"personal"}'
render_scenario "work" '{"purpose":"work"}'
render_scenario "consulting" '{"purpose":"consulting"}'

for source in \
  agent-rules/profiles/public-content.md \
  agent-rules/skills/public-content-extractor.md \
  agent-rules/skills/confidentiality-guardian.md \
  agent-rules/skills/thought-leadership-editor.md \
  agent-rules/skills/research-agenda-manager.md
do
  test -s "$source"
done

grep -q "W2 source" agent-rules/skills/public-content-extractor.md
grep -q "Consulting source" agent-rules/skills/public-content-extractor.md
grep -q "client-contract" agent-rules/skills/confidentiality-guardian.md

for skill in \
  public-content-extractor \
  confidentiality-guardian \
  thought-leadership-editor \
  research-agenda-manager
do
  skill_dir="dot_codex/skills/$skill"
  test -s "$skill_dir/SKILL.md"
  test -s "$skill_dir/agents/openai.yaml"

  chezmoi target-path "$skill_dir/SKILL.md" | grep -q "/.codex/skills/$skill/SKILL.md$"
  grep -q "name: $skill" "$skill_dir/SKILL.md"
  grep -q "description:" "$skill_dir/SKILL.md"
  grep -Fq "Use \$$skill" "$skill_dir/agents/openai.yaml"

  if grep -q "TODO" "$skill_dir/SKILL.md" "$skill_dir/agents/openai.yaml"; then
    echo "TODO placeholder left in $skill_dir" >&2
    exit 1
  fi
done

ruby - <<'RUBY'
require "yaml"

%w[
  public-content-extractor
  confidentiality-guardian
  thought-leadership-editor
  research-agenda-manager
].each do |skill|
  dir = File.join("dot_codex", "skills", skill)
  skill_md = File.read(File.join(dir, "SKILL.md"))
  abort("missing frontmatter for #{skill}") unless skill_md.start_with?("---\n")

  frontmatter = skill_md.split("---\n", 3)[1]
  metadata = YAML.safe_load(frontmatter)
  abort("wrong skill name for #{skill}") unless metadata["name"] == skill
  abort("short description for #{skill}") unless metadata["description"].to_s.length > 80

  openai = YAML.safe_load(File.read(File.join(dir, "agents", "openai.yaml")))
  prompt = openai.dig("interface", "default_prompt").to_s
  abort("default prompt missing $#{skill}") unless prompt.include?("$#{skill}")
end
RUBY

echo "agent rule validation passed"
