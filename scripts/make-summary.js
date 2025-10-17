// scripts/make-summary.js
const fs = require("fs");
const path = require("path");

// Point this at the folders you want in your GitBook nav.
const ROOTS = [
  "3.0-Health-and-Nutrition-Knowledge-Base/3.6-Dr-Berg-YouTube-Videos"
];

const IGNORE_DIRS = new Set([".git", ".github", "node_modules", "scripts"]);
const isMd = f => f.toLowerCase().endsWith(".md");

function toTitle(name) {
  const cleared = name.replace(/^\d+[-_ ]*/, "").replace(/-/g, " ");
  return cleared.replace(/\.md$/i, "").replace(/\b\w/g, m => m.toUpperCase());
}

function ncmp(a, b) {
  return a.localeCompare(b, undefined, { numeric: true, sensitivity: "base" });
}

function walk(dir, depth = 0) {
  const items = fs.readdirSync(dir, { withFileTypes: true }).sort((a, b) => ncmp(a.name, b.name));
  let lines = [];

  const hasReadme = items.some(x => x.isFile() && x.name.toLowerCase() === "readme.md");
  const folderTitle = toTitle(path.basename(dir));

  if (hasReadme) {
    const rel = path.join(dir, "README.md").replace(/\\/g, "/");
    lines.push(`${"  ".repeat(depth)}* [${folderTitle}](${rel})`);
  } else {
    lines.push(`${"  ".repeat(depth)}* ${folderTitle}`);
  }

  for (const it of items) {
    if (it.isFile() && isMd(it.name)) {
      const lower = it.name.toLowerCase();
      if (lower === "readme.md" || it.name === "SUMMARY.md") continue;
      const rel = path.join(dir, it.name).replace(/\\/g, "/");
      lines.push(`${"  ".repeat(depth + 1)}* [${toTitle(it.name)}](${rel})`);
    }
  }

  for (const it of items) {
    if (it.isDirectory() && !IGNORE_DIRS.has(it.name)) {
      lines = lines.concat(walk(path.join(dir, it.name), depth + 1));
    }
  }

  return lines;
}

function main() {
  let out = ["# Summary"];
  if (fs.existsSync("README.md")) out.push("* [Home](README.md)");

  for (const root of ROOTS) {
    if (!fs.existsSync(root)) {
      console.error("Missing root:", root);
      continue;
    }
    out = out.concat(walk(root, 0));
  }

  fs.writeFileSync("SUMMARY.md", out.join("\n") + "\n", "utf8");
  console.log("SUMMARY.md generated");
}

main();
