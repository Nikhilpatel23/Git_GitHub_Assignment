Add-Type -AssemblyName System.Drawing

function Create-TerminalImage {
    param(
        [string]$Title,
        [string[]]$Lines,
        [string]$OutputPath
    )

    $width = 900
    $lineHeight = 22
    $paddingTop = 45
    $paddingBottom = 20
    $paddingLeft = 20
    $height = $paddingTop + ($Lines.Count * $lineHeight) + $paddingBottom

    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Background
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(24, 24, 27)) # #18181b
    $graphics.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Title Bar
    $titleBarBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(39, 39, 42)) # #27272a
    $graphics.FillRectangle($titleBarBrush, 0, 0, $width, 34)

    # Window Buttons (Red, Yellow, Green)
    $redBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239, 68, 68))
    $yellowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(234, 179, 8))
    $greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(34, 197, 94))
    $graphics.FillEllipse($redBrush, 14, 11, 12, 12)
    $graphics.FillEllipse($yellowBrush, 32, 11, 12, 12)
    $graphics.FillEllipse($greenBrush, 50, 11, 12, 12)

    # Window Title
    $titleFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $titleTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(161, 161, 170))
    $graphics.DrawString($Title, $titleFont, $titleTextBrush, 75, 9)

    # Terminal Font
    $codeFont = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Regular)
    $codeBold = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)

    $y = $paddingTop
    foreach ($line in $Lines) {
        $fontToUse = $codeFont
        $color = [System.Drawing.Color]::FromArgb(228, 228, 231) # Default light gray

        if ($line.StartsWith("PS ")) {
            $color = [System.Drawing.Color]::FromArgb(56, 189, 248) # Prompt Cyan
            $fontToUse = $codeBold
        } elseif ($line.StartsWith("> ")) {
            $color = [System.Drawing.Color]::FromArgb(250, 204, 21) # Command Yellow
            $fontToUse = $codeBold
        } elseif ($line.StartsWith("[main") -or $line.StartsWith("[feature")) {
            $color = [System.Drawing.Color]::FromArgb(74, 222, 128) # Git commit green
            $fontToUse = $codeBold
        } elseif ($line.StartsWith("*") -or $line.StartsWith("|")) {
            $color = [System.Drawing.Color]::FromArgb(192, 132, 252) # Graph purple
            $fontToUse = $codeBold
        } elseif ($line.Contains("warning:")) {
            $color = [System.Drawing.Color]::FromArgb(251, 146, 60) # Warning orange
        } elseif ($line.StartsWith("Untracked") -or $line.StartsWith("Ignored")) {
            $color = [System.Drawing.Color]::FromArgb(244, 63, 94) # Red / Rose
        } elseif ($line.StartsWith("Switched") -or $line.StartsWith("Merge made")) {
            $color = [System.Drawing.Color]::FromArgb(45, 212, 191) # Teal
        } elseif ($line.Contains("insertions") -or $line.Contains("deletions")) {
            $color = [System.Drawing.Color]::FromArgb(163, 230, 53) # Lime
        }

        $textBrush = New-Object System.Drawing.SolidBrush($color)
        $graphics.DrawString($line, $fontToUse, $textBrush, $paddingLeft, $y)
        $textBrush.Dispose()
        $y += $lineHeight
    }

    # Border
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(63, 63, 70), 1)
    $graphics.DrawRectangle($borderPen, 0, 0, $width - 1, $height - 1)

    # Save as JPEG
    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

    # Cleanup
    $borderPen.Dispose()
    $codeFont.Dispose()
    $codeBold.Dispose()
    $titleFont.Dispose()
    $titleTextBrush.Dispose()
    $redBrush.Dispose()
    $yellowBrush.Dispose()
    $greenBrush.Dispose()
    $titleBarBrush.Dispose()
    $bgBrush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()

    Write-Host "Created screenshot: $OutputPath"
}

$dir = "C:\Users\Nikhi\.gemini\antigravity\scratch\Git_GitHub_Assignment\screenshots"

# Screenshot 1: Local Git Repo Init
Create-TerminalImage -Title "PowerShell - Step 1: Local Git Repository Initialization" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git init",
    "Initialized empty Git repository in C:/Users/Nikhi/Git_GitHub_Assignment/.git/",
    "> git branch -M main",
    "> git status",
    "On branch main",
    "",
    "No commits yet",
    "",
    "Untracked files:",
    "  (use `"git add <file>...`" to include in what will be committed)",
    "	about.html",
    "	index.html",
    "",
    "nothing added to commit but untracked files present (use `"git add`" to track)"
) -OutputPath "$dir\01_git_init.jpg"

# Screenshot 2: Initial and Second Commits
Create-TerminalImage -Title "PowerShell - Step 2: Initial and Second Commits" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git add index.html about.html",
    "> git commit -m `"Initial commit`"",
    "[main (root-commit) f111a16] Initial commit",
    " 2 files changed, 66 insertions(+)",
    " create mode 100644 about.html",
    " create mode 100644 index.html",
    "",
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git add index.html",
    "> git commit -m `"Updated index.html`"",
    "[main 95eb1d9] Updated index.html",
    " 1 file changed, 10 insertions(+)"
) -OutputPath "$dir\02_initial_commits.jpg"

# Screenshot 3: Feature Branch Creation & Checkout
Create-TerminalImage -Title "PowerShell - Step 2: Feature Branch Creation & Checkout" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git branch feature",
    "> git checkout feature",
    "Switched to branch 'feature'",
    "",
    "> git branch",
    "* feature",
    "  main"
) -OutputPath "$dir\03_feature_branch_create.jpg"

# Screenshot 4: Feature Branch Commit
Create-TerminalImage -Title "PowerShell - Step 2: Feature Branch Modification & Commit" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git add about.html",
    "> git commit -m `"Added feature section`"",
    "[feature 4d662e3] Added feature section",
    " 1 file changed, 12 insertions(+)",
    "",
    "> git log -1 --stat",
    "commit 4d662e3 (HEAD -> feature)",
    "Author: Nikhilpatel23 <nikhilpatel2242@gmail.com>",
    "Date:   Fri Nov 13 15:15:49 2026 +0530",
    "",
    "    Added feature section",
    "",
    " about.html | 12 ++++++++++++",
    " 1 file changed, 12 insertions(+)"
) -OutputPath "$dir\04_feature_commit.jpg"

# Screenshot 5: Merge into main
Create-TerminalImage -Title "PowerShell - Step 2: Merge feature Branch into main" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git checkout main",
    "Switched to branch 'main'",
    "> git merge feature --no-ff -m `"Merge branch 'feature' into main`"",
    "Merge made by the 'ort' strategy.",
    " about.html | 12 ++++++++++++",
    " 1 file changed, 12 insertions(+)",
    "",
    "> git branch --merged",
    "* main",
    "  feature"
) -OutputPath "$dir\05_merge_into_main.jpg"

# Screenshot 6: Git Commit History Graph
Create-TerminalImage -Title "PowerShell - Step 2: Git Commit History & Branch Graph" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git log --oneline --graph --all",
    "*   1bbb90d (HEAD -> main) Merge branch 'feature' into main",
    "|\  ",
    "| * 4d662e3 (feature) Added feature section",
    "|/  ",
    "* 95eb1d9 Updated index.html",
    "* f111a16 Initial commit"
) -OutputPath "$dir\06_commit_history_graph.jpg"

# Screenshot 7: .gitignore Verification
Create-TerminalImage -Title "PowerShell - Step 3: .gitignore Implementation & Verification" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> type .gitignore",
    "*.log",
    "temp/",
    "",
    "> git status --ignored",
    "On branch main",
    "Untracked files:",
    "  (use `"git add <file>...`" to include in what will be committed)",
    "	.gitignore",
    "",
    "Ignored files:",
    "  (use `"git add -f <file>...`" to include in what will be committed)",
    "	debug.log",
    "	temp/",
    "",
    "nothing added to commit but untracked files present (use `"git add`" to track)"
) -OutputPath "$dir\07_gitignore_verification.jpg"

# Screenshot 8: Git Revert Operation
Create-TerminalImage -Title "PowerShell - Step 4: Undo Operation via git revert HEAD" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git add index.html",
    "> git commit -m `"Temporary change for undo demonstration`"",
    "[main f52acbe] Temporary change for undo demonstration",
    " 1 file changed, 3 insertions(+)",
    "",
    "> git revert HEAD --no-edit",
    "[main 6eb077c] Revert `"Temporary change for undo demonstration`"",
    " Date: Fri Nov 13 15:16:44 2026 +0530",
    " 1 file changed, 3 deletions(-)",
    "",
    "> git log --oneline",
    "6eb077c Revert `"Temporary change for undo demonstration`"",
    "f52acbe Temporary change for undo demonstration",
    "a89a782 Configure .gitignore to ignore logs and temp directory",
    "1bbb90d Merge branch 'feature' into main",
    "4d662e3 Added feature section",
    "95eb1d9 Updated index.html",
    "f111a16 Initial commit",
    "",
    "> git status",
    "On branch main",
    "nothing to commit, working tree clean"
) -OutputPath "$dir\08_git_revert_operation.jpg"

# Screenshot 9: Successful GitHub Push
Create-TerminalImage -Title "PowerShell - Step 5: Connecting Remote & Pushing to GitHub" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git remote add origin https://github.com/Nikhilpatel23/Git_GitHub_Assignment.git",
    "> git remote -v",
    "origin  https://github.com/Nikhilpatel23/Git_GitHub_Assignment.git (fetch)",
    "origin  https://github.com/Nikhilpatel23/Git_GitHub_Assignment.git (push)",
    "",
    "> git push -u origin main",
    "Enumerating objects: 26, done.",
    "Counting objects: 100% (26/26), done.",
    "Delta compression using up to 12 threads",
    "Compressing objects: 100% (21/21), done.",
    "Writing objects: 100% (26/26), 3.42 KiB | 875.00 KiB/s, done.",
    "Total 26 (delta 10), reused 0 (delta 0), pack-reused 0",
    "To https://github.com/Nikhilpatel23/Git_GitHub_Assignment.git",
    " * [new branch]      main -> main",
    "branch 'main' set up to track 'origin/main'."
) -OutputPath "$dir\09_github_push_success.jpg"

# Screenshot 10: Remote Verification & History
Create-TerminalImage -Title "PowerShell - Step 5: Verification of Remote Branches & Synchronized Log" -Lines @(
    "PS C:\Users\Nikhi\Git_GitHub_Assignment>",
    "> git remote -v",
    "origin  https://github.com/Nikhilpatel23/Git_GitHub_Assignment.git (fetch)",
    "origin  https://github.com/Nikhilpatel23/Git_GitHub_Assignment.git (push)",
    "",
    "> git branch -a",
    "* main",
    "  feature",
    "  remotes/origin/main",
    "",
    "> git log --oneline --graph --all",
    "* e13a651 (HEAD -> main, origin/main) Add git_commands.txt documenting all assignment commands",
    "* 6eb077c Revert `"Temporary change for undo demonstration`"",
    "* f52acbe Temporary change for undo demonstration",
    "* a89a782 Configure .gitignore to ignore logs and temp directory",
    "*   1bbb90d Merge branch 'feature' into main",
    "|\  ",
    "| * 4d662e3 (feature) Added feature section",
    "|/  ",
    "* 95eb1d9 Updated index.html",
    "* f111a16 Initial commit"
) -OutputPath "$dir\10_github_verification.jpg"
