param(
  [string]$Root = "."
)

# Folders to ignore anywhere in the tree
$EXCLUDE_DIRS = @('.git', '.github', '.gitbook', 'node_modules', '.vscode', '.idea', 'scripts')

function ToTitle([string]$name) {
  $t = $name -replace '^\d+[-_ ]*',''
  $t = $t -replace '\.md$','' -replace '[-_]',' '
  (Get-Culture).TextInfo.ToTitleCase($t.ToLower())
}

function NaturalKey([string]$s) {
  [regex]::Replace($s, '\d+', { param($m) $m.Value.PadLeft(6,'0') })
}

# Compute paths relative to the chosen root
$RootPath = (Resolve-Path $Root).Path
function RelPath([string]$full) {
  ($full.Substring($RootPath.Length + 1)).Replace('\','/')
}

$OutFile = Join-Path $RootPath "SUMMARY.md"

function WriteSection([string]$dir, [int]$depth) {
  $indent = '  ' * $depth
  $items = Get-ChildItem -LiteralPath $dir -Force | Sort-Object @{Expression={ NaturalKey $_.Name }}

  $folderTitle = ToTitle (Split-Path $dir -Leaf)
  $readme = Join-Path $dir "README.md"
  if (Test-Path $readme) {
    "$indent* [$folderTitle]($(RelPath $readme))" | Out-File -FilePath $OutFile -Append -Encoding utf8
  } else {
    "$indent* $folderTitle" | Out-File -FilePath $OutFile -Append -Encoding utf8
  }

  foreach ($f in $items | Where-Object { -not $_.PSIsContainer -and $_.Name -like "*.md" -and $_.Name -notin @("README.md","SUMMARY.md") }) {
    "$indent  * [$(ToTitle $f.Name)]($(RelPath $f.FullName))" | Out-File -FilePath $OutFile -Append -Encoding utf8
  }

  foreach ($sub in $items | Where-Object { $_.PSIsContainer -and $EXCLUDE_DIRS -notcontains $_.Name }) {
    WriteSection -dir $sub.FullName -depth ($depth + 1)
  }
}

# Build SUMMARY.md inside the root
"# Summary" | Out-File -FilePath $OutFile -Encoding utf8
if (Test-Path (Join-Path $RootPath "README.md")) { "* [Home](README.md)" | Out-File -FilePath $OutFile -Append -Encoding utf8 }

# Root-level files first
Get-ChildItem -LiteralPath $RootPath -File -Filter *.md |
  Where-Object { $_.Name -notin @("README.md","SUMMARY.md") } |
  Sort-Object @{Expression={ NaturalKey $_.Name }} |
  ForEach-Object {
    "* [$(ToTitle $_.Name)]($(RelPath $_.FullName))" | Out-File -FilePath $OutFile -Append -Encoding utf8
  }

# Then all subfolders
Get-ChildItem -LiteralPath $RootPath -Directory |
  Where-Object { $EXCLUDE_DIRS -notcontains $_.Name } |
  Sort-Object @{Expression={ NaturalKey $_.Name }} |
  ForEach-Object { WriteSection -dir $_.FullName -depth 0 }

Write-Host "SUMMARY.md generated at $OutFile"
