# make-summary-all.ps1  - generate SUMMARY.md for the whole repo

# Folders to ignore anywhere in the tree
$EXCLUDE_DIRS = @('.git', '.github', '.gitbook', 'node_modules', '.vscode', '.idea', 'scripts')

function ToTitle([string]$name) {
  $t = $name -replace '^\d+[-_ ]*',''
  $t = $t -replace '\.md$','' -replace '[-_]',' '
  (Get-Culture).TextInfo.ToTitleCase($t.ToLower())
}

# Natural sort key: pad numbers so 2 < 10
function NaturalKey([string]$s) {
  return [regex]::Replace($s, '\d+', { param($m) $m.Value.PadLeft(6,'0') })
}

function RelPath([string]$full) {
  ($full.Substring((Get-Location).Path.Length + 1)).Replace('\','/')
}

function WriteSection([string]$dir, [int]$depth) {
  $indent = '  ' * $depth
  $items = Get-ChildItem -LiteralPath $dir -Force | Sort-Object @{Expression={ NaturalKey $_.Name }}

  $folderTitle = ToTitle (Split-Path $dir -Leaf)
  $readme = Join-Path $dir "README.md"
  if (Test-Path $readme) {
    "$indent* [$folderTitle]($(RelPath $readme))" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8
  } else {
    "$indent* $folderTitle" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8
  }

  # Files in this folder
  foreach ($f in $items | Where-Object { -not $_.PSIsContainer -and $_.Name -like "*.md" -and $_.Name -notin @("README.md","SUMMARY.md") }) {
    "$indent  * [$(ToTitle $f.Name)]($(RelPath $f.FullName))" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8
  }

  # Recurse into subfolders
  foreach ($sub in $items | Where-Object { $_.PSIsContainer -and $EXCLUDE_DIRS -notcontains $_.Name }) {
    WriteSection -dir $sub.FullName -depth ($depth + 1)
  }
}

# Start fresh
"# Summary" | Out-File -FilePath SUMMARY.md -Encoding utf8

# Root landing page if present
if (Test-Path "README.md") { "* [Home](README.md)" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8 }

# Root level markdown files first
Get-ChildItem -File -Filter *.md | Where-Object { $_.Name -notin @("README.md","SUMMARY.md") } |
  Sort-Object @{Expression={ NaturalKey $_.Name }} |
  ForEach-Object {
    "* [$(ToTitle $_.Name)]($(RelPath $_.FullName))" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8
  }

# Then every top level folder except excluded ones
Get-ChildItem -Directory | Where-Object { $EXCLUDE_DIRS -notcontains $_.Name } |
  Sort-Object @{Expression={ NaturalKey $_.Name }} |
  ForEach-Object { WriteSection -dir $_.FullName -depth 0 }

Write-Host "SUMMARY.md generated for the whole repo."
