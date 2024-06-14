This is a PowerShell script I wrote to help with streamlining VS-Code extension installations.
By running the command ./Installer.ps1 from saved location you will be prompted with a menu
You can move up and down via arrow-keys and press enter to make selections.

I've broken down extension categories into seperate functions for easy navigation and selection.
Inside each category you will find a selection of extensions you can choose from.
This list of extensions will change and evolve over time.


If you want to use this for your own purposes you can block out each extension by adding a # in front 
of the line that includes the extension not wanted.

Easiest way to add a new extension is to right-click and copy extension ID from the marketplace and
then find the function which includes your category and add a line like below
@( Name = "Name"; Id = "publisher.extension" )

You have to include at least TWO extensions per function or the first one will not work.
And it must include a comma like below

@( Name = "Name1"; Id = "publisher.extension1" ),
@( Name = "Name2"; Id = "publisher.extension2" )


Version One June 14th 2024

Written by
Jason Kay