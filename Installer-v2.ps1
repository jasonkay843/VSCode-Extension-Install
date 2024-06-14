function Show-Menu {
    param (
        [string[]]$MenuItems,
        [string]$PromptMessage = "Select an option (use arrow keys to navigate and Enter to select):"
    )

    $currentSelection = 0
    [System.Console]::CursorVisible = $false

    while ($true) {
        Clear-Host
        Write-Host $PromptMessage
        for ($i = 0; $i -lt $MenuItems.Length; $i++) {
            if ($MenuItems[$i] -eq "Return to Main Menu" -or $MenuItems[$i] -eq "Exit") {
                if ($i -gt 0) {
                    Write-Host ""  # Add a blank line before "Return to Main Menu" and "Exit"
                }
            }

            if ($i -eq $currentSelection) {
                Write-Host "=> $($MenuItems[$i])" -ForegroundColor Cyan
            } else {
                Write-Host "   $($MenuItems[$i])"
            }
        }

        $key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode

        switch ($key) {
            38 {  # Up Arrow
                do {
                    $currentSelection = ($currentSelection - 1) % $MenuItems.Length
                    if ($currentSelection -lt 0) { $currentSelection += $MenuItems.Length }
                } while ($MenuItems[$currentSelection] -eq '')
            }
            40 {  # Down Arrow
                do {
                    $currentSelection = ($currentSelection + 1) % $MenuItems.Length
                } while ($MenuItems[$currentSelection] -eq '')
            }
            13 {  # Enter
                if ($MenuItems[$currentSelection] -ne '') {
                    [System.Console]::CursorVisible = $true
                    return $MenuItems[$currentSelection]
                }
            }
        }
    }
}

function Install-Extensions {
    $mainMenuItems = @(
        "Linters"
        "HTML Extensions",
        "Java Extensions",
        "Extension Packs",
        "Other Extensions",
        
        "Exit"
    )

    while ($true) {
        $selection = Show-Menu -MenuItems $mainMenuItems -PromptMessage "Select the type of extensions to install:"

        switch ($selection) {
            "Linters" {
                Install-Linters
            }
            "HTML Extensions" {
                Install-HTMLExtensions
            }
            "Java Extensions" {
                Install-JavaExtensions
            }
            "Extension Packs" {
                Install-ExtensionPacks
            }
            "Other Extensions" {
                Install-OtherExtensions
            }                       
            "Exit" {
                exit
            }
        }
    }
}

function Install-HTMLExtensions {
    $htmlExtensions = @(

        # Add a # in front of any line to not run that extension

        # How to add extensions to the script
        # "publisher.extension-name"

        # Working example

        @{ Name = "HTML5 Boilerplate"; Id = "sidthesloth.html5-boilerplate" },

        # Add more HTML extensions here if needed
        @{ Name = "HTML CSS Support"; Id = "ecmel.vscode-html-css" },
        @{ Name = "HTML to CSS Autocompletion"; Id = "solnurkarim.html-to-css-autocompletion" },
        @{ Name = "Class Autocomplete"; Id = "AESSoft.aessoft-class-autocomplete" },
        @{ Name = "Live Server"; Id = "ritwickdey.LiveServer" }
    )

    Install-ExtensionSelection -extensions $htmlExtensions
}

function Install-JavaExtensions {
    $javaExtensions = @(

    # Add a # in front of any line to not run that extension

    # How to add extensions to the script
    # "publisher.extension-name"

    # Working example

        @{ Name = "JavaScript Snippets"; Id = "xabikos.JavaScriptSnippets" },
        @{ Name = "Javascript Booster"; Id = "sburg.vscode-javascript-booster" }

        # Add more Java extensions here if needed
    )

    Install-ExtensionSelection -extensions $javaExtensions
}

function Install-ExtensionPacks {
    $extensionPacks = @(

        # Add a # in front of any line to not run that extension

        # How to add extensions to the script
        # "publisher.extension-name"

        # Working example

        @{ Name = "Jupyter"; Id = "ms-toolsai.jupyter" },

        # Add more extension packs for customizing VSCode or formatting here if needed
        @{ Name = "Java Pack"; Id = "vscjava.vscode-java-pack" },
        @{ Name = "Remote Extension Pack"; Id = "ms-vscode-remote.vscode-remote-extensionpack" },
        @{ Name = "Python Extension Pack"; Id = "donjayamanne.python-extension-pack" },
        @{ Name = "Salesforce Extension Pack"; Id = "salesforce.salesforcedx-vscode" },
        @{ Name = "Node Azure Pack"; Id = "ms-vscode.vscode-node-azure-pack" },
        @{ Name = "Dotnet Pack"; Id = "ms-dotnettools.vscode-dotnet-pack" }
    )

    Install-ExtensionSelection -extensions $extensionPacks
}

# Other extension installations
# Like Prettier

function Install-OtherExtensions {
    $otherExtensions = @(

        # Add a # in front of any line to not run that extension

        # How to add extensions to the script
        # "publisher.extension-name"

        # Working example
        @{ Name = "Prettier"; Id = "esbenp.prettier-vscode" },

        # Add more extensions for customizing VSCode or formatting here if needed
        @{ Name = "Intellicode"; Id = "VisualStudioExptTeam.vscodeintellicode" },
        @{ Name = "Remote WSL"; Id = "ms-vscode-remote.remote-wsl" },
        @{ Name = "Doxygen Documentation Generator"; Id = "cschlosser.doxdocgen" },
        @{ Name = "Indent Rainbow"; Id = "oderwat.indent-rainbow" },
        @{ Name = "Project Manager"; Id = "alefragnani.project-manager" },
        @{ Name = "Todo Tree"; Id = "Gruntfuggly.todo-tree" }

    )

    Install-ExtensionSelection -extensions $otherExtensions
}

function Install-Linters {
    $linterExtensions = @(

        # Add a # in front of any line to not run that extension

        # How to add extensions to the script
        # "publisher.extension-name"

        # Working example

        @{ Name = "ESLint"; Id = "dbaeumer.vscode-eslint" },
        # Add more Linters here if needed
        @{ Name = "Linter"; Id = "kddejong.vscode-cfn-lint" }

    )

    Install-ExtensionSelection -extensions $linterExtensions
}

function Install-ExtensionSelection {
    param (
        [array]$extensions
    )

    $selectionMenuItems = $extensions | ForEach-Object { $_.Name }
    $selectionMenuItems += "Install All"
    $selectionMenuItems += ""
    $selectionMenuItems += "Return to Main Menu"  # Adding return option

    $selection = Show-Menu -menuItems $selectionMenuItems -promptMessage "Select the extensions to install:"

    if ($selection -eq "Install All") {
        foreach ($extension in $extensions) {
            code --install-extension $extension.Id
            Write-Output "Installed $($extension.Name)"
        }
    } elseif ($selection -eq "Return to Main Menu") {
        return  # Returning to the main menu
    } else {
        $selectedExtension = $extensions | Where-Object { $_.Name -eq $selection }
        code --install-extension $selectedExtension.Id
        Write-Output "Installed $($selectedExtension.Name)"
    }
}

# Run the Install Extensions script
# From terminal ./Installer.ps1 or whatever you have called it.
Install-Extensions
