"""Validate distributable files only; this does not assess PPT fidelity."""
import json
import re
from pathlib import Path
from urllib.parse import unquote


def validate(root):
    skill = root / "skills" / "slide-rebuild"
    errors = []
    required = ["README.md", "LICENSE", "skills/slide-rebuild/SKILL.md",
                "skills/slide-rebuild/acceptance.md", "skills/slide-rebuild/checklist.md",
                "skills/slide-rebuild/agents/openai.yaml"]
    for relative in required:
        if not (root / relative).is_file():
            errors.append(f"Missing {relative}")
    entry = skill / "SKILL.md"
    if entry.is_file():
        text = entry.read_text(encoding="utf-8-sig")
        frontmatter = re.match(r"\A---\n(.*?)\n---", text, re.S)
        if not frontmatter or not re.search(r"^name: slide-rebuild$", frontmatter[1], re.M):
            errors.append("Invalid skill name/frontmatter")
    checked = 0
    files = [root / "README.md", *skill.rglob("*.md")]
    for path in files:
        if not path.is_file():
            continue
        text = path.read_text(encoding="utf-8-sig")
        if re.search(r"(?i)\b[A-Z]:[\\/]", text):
            errors.append(f"Machine-specific absolute path in {path.relative_to(root)}")
        for target in re.findall(r"\[[^\]]*\]\(([^)]+)\)", text):
            if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:", target) or target.startswith("#"):
                continue
            resolved = (path.parent / unquote(target.split("#")[0])).resolve()
            if not resolved.is_relative_to(root.resolve()) or not resolved.exists():
                errors.append(f"Broken/outside link: {path.relative_to(root)} -> {target}")
            checked += 1
    for path in skill.rglob("*.json"):
        try:
            json.loads(path.read_text(encoding="utf-8-sig"))
        except (ValueError, UnicodeError) as exc:
            errors.append(f"Invalid JSON: {path.relative_to(root)}: {exc}")
    return {"passed": not errors, "links_checked": checked, "errors": errors,
            "scope": "package structure only; no PowerPoint or visual test"}


if __name__ == "__main__":
    result = validate(Path(__file__).resolve().parents[1])
    print(json.dumps(result, ensure_ascii=False, indent=2))
    raise SystemExit(0 if result["passed"] else 1)
