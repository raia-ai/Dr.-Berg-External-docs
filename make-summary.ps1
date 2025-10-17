# make-summary.ps1  - generate SUMMARY.md for GitBook

$Roots = @(
  "3.0-Health-and-Nutrition-Knowledge-Base\3.6-Dr-Berg-YouTube-Videos"
  # Add more folders here if you want them included
)

function ToTitle([string]$name) {
  $t = $name -replace '^\d+[-_ ]*',''
  $t = $t -replace '\.md$','' -replace '[-_]',' '
  (Get-Culture).TextInfo.ToTitleCase($t.ToLower())
}

function RelPath([string]$full) {
  ($full.Substring((Get-Location).Path.Length + 1)).Replace('\','/')
}

function WriteSection([string]$dir, [int]$depth) {
  $items = Get-ChildItem -LiteralPath $dir -Force | Sort-Object Name
  $indent = '  ' * $depth

  $folderTitle = ToTitle (Split-Path $dir -Leaf)
  $readme = Join-Path $dir "README.md"
  if (Test-Path $readme) {
    "$indent* [$folderTitle]($(RelPath $readme))" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8
  } else {
    "$indent* $folderTitle" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8
  }

  # Files in this folder
  foreach ($f in $items | Where-Object { $_.PSIsContainer -eq $false -and $_.Name -like "*.md" -and $_.Name -ne "README.md" -and $_.Name -ne "SUMMARY.md" }) {
    "$indent  * [$(ToTitle $f.Name)]($(RelPath $f.FullName))" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8
  }

  # Recurse into subfolders
  foreach ($sub in $items | Where-Object { $_.PSIsContainer -eq $true -and $_.Name -notin @('.git','.github','node_modules','scripts') }) {
    WriteSection -dir $sub.FullName -depth ($depth + 1)
  }
}

# Start fresh
"# Summary" | Out-File -FilePath SUMMARY.md -Encoding utf8
if (Test-Path "README.md") { "* [Home](README.md)" | Out-File -FilePath SUMMARY.md -Append -Encoding utf8 }

foreach ($r in $Roots) {
  if (-not (Test-Path $r)) { Write-Host "Missing folder: $r"; continue }
  WriteSection -dir $r -depth 0
}

Write-Host "SUMMARY.md generated."
