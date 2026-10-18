# review 3

this review is done on a fresh install of ojuny via the setup script, this is a review of both for nix-settings-gui's custom modules for ojuny *and* for the template itself. 

the template repo owns ordering, what is visible, how things are named and how widgets are applied

the nix-settings-gui repo owns the shape of the custom ojuny widgets, the functions of the gui, rendering etc. 

the review is done by going through each page in nix-settings-gui on the test machine. 

# 01-Users

## user account

shell shouldn't be a raw, we could do with pkgs; to take pkgs out of the scope, and give a dropdown between zsh, bash, fish. 

also under Account (group name) it just lists "den", i don't know why, i'm guessing it's because the user description was set there too or this is the display of the account name (non-writeable)

## common settings

good

# 02-Core

## display

icon is missing

monitors module looks pretty decent, but some items don't default sensibly, the add monitor prompt should be a pop-up that detects the monitor's name, refreshrate, width and height, prompting the user only to select one of their monitors, they can then position them interactively using the menu. the theming for this graphic is not correct and the x/y currently start at -16K when they should default to 0, scale should default to 1.00, RR should be called transform and should be based on the details from the actual mango config (~/repos/mango/docs)

monitors also need to snap to eachother when dragged around in the gui, and the canvas on which the monitors are dragged should be taller and be a different color to distinguish it, it should also always be the maximum width of the gui, not shrink if monitor positions allow it. 

saving with it and the gui updating when values are set via the toggles doesn't quite work correctly, things get desynced quite frequently.

we might also want to change out refresh, width and height to always be selectors with the selected monitor's reported refresh rate and resolution options. the user can then just select one of those which nix-settings-gui parses. 

current version also forces towards Y=-16K for some reason

## input

looks good

## keybinds

this needs to be completely reworked, all the details are lost and currently it is shown as:

name (editable field)
mods (editable field)
keys (editable field)
mod+key (preview)
edit (Fold-out menu)
delete button

the entire fold-out menu is a mess, instead, what i'd like is:

left-alligned: name + description subtext 
right-alligned: [preview of keys] [edit] [delete]

preview needs to be styled with a different background color, edit is *not* a foldout, it is a button, pressing it opens a pop-up menu that simply lists all the individual fields from that keybind as their relevant widgets

currently the edit foldout also moves when it is opened, which is very weird, it also makes the cells incredibly tall which looks ugly, hence a pop-out that does not reflow the UI would be better.

## gestures

should be a set list of options for each available gesture in mango, with only an enable/disable toggle and the relevant command as fields (horizontal submodule)

## style

color palette is not using the custom module, looks like a simple text field now. 

stylix enable and theme mango from stylix settings should be hidden/advanced

gaps - individual gaps are still available even if set gaps per edge is disabled

set border thickness per surface - individual surfaces are still listed even with it disabled

shadows - settings are still shown with shadows disabled

animations - layer animations toggle and other opts should be below fade out. 

## browser

looks good on firefox

switching to chrome - firefox is still visible, no chrome settings. 

## git

packages should be advanced, git should not have an exposed toggle (always enabled)

## terminal

needs a btop.enable so it gets stylix-themed, aliasses need to be turned into a table with an "add alias" button

## startup

looks fine

## updates

looks fine

## nix settings

looks fine

# 03-Desktop

## login

this entire file should be hidden menu.

## window management

looks fine, though special workspace dim should move to workspaces. 

## master layout

im sure there are more master layout settings than this? double-check, otherwise looks fine

## dwindle layout

there are more dwindle settings than this, and they should all be user-exposed, not hidden/advanced

## scroller layout

looks good 

## workspaces

looks good

## notifications

clipboard is not related to notifications, should probably move to its own file.

# 04-GUI

## bar

leftwidgets item is a *mess*. we have to completely redesign it, same for rightwidgets. 

furthermore, some settings that do not need to be shown to the user directly are here, and some should be put into horizontal submodules together. eg autohide and autohidedelay. 

also, the _order fields make zero sense and have zero explanation, nothing has any explanation here. 

## dock

dock widgets module is... ok, but shouldn't use dock_launcher style names and _order will not make sense to the end user, nothing has descriptive names here.

same issues as bar 

## launcher

fine

## dashboard

looks decent, except the col/row/w/h sections, we should turn those into tables, and allow the user to add/remove rows, this might need a custom module

## control center

same as dashboard, but because the enable toggles are in here as well it's really messy. 

## ojuny menu

extra plugin settings should be at the bottom, manage menu with nix is toggle-less and is a floating option, it should be removed (always enabled)

this module likewise needs a full rework. 

# 05-Applications

## installed applications

looks fine

## multimedia

looks mostly fine, though the 4 apps at the top have no descriptions

## office

craftapps section is completely the wrong way around, it has the names editable, but the false : behind it without edits. 

opendocuments defaults should only be visible if libreoffice is enabled, it's currently disabled and they are still visible.

## vesktop

likewise vesktop settings are visible with vesktop disabled, otherwise they look fine.

## gaming

again, steam-related settings are shown even with steam disabled most likely. 

# 06-Utility

## web apps

works correctly! but the "webapps" title is shown twice, once with the description, and once more after. the labels for the columns are also not alligned. 

## DMS plugins

this module is a complete mess, it's a list of various raw option names (editable) with "add plugin" below, each list also has a toggle which are all set to false atm. needs a full rework

## phone connect

control center widget needs to be moved to control center with the rest of its modules, bar widget needs to be moved to bar widget setup. KDE connect toggle can move to applications, this menu can be deprecated

# 07-System

## system

text doesn't span the whole width for something like hostname, which has quite a large description. this causes the option menu to need scrolling for only 4 options. 

## networking

looks good

## bluetooth

looks good 

## graphics

shows all 3 vendors regardless, also unsure if options from other vendors are still applying with a specific vendor set, also "none" needs to be an option that applies no specific-vendor settings, only general ones.

# patches

## development

aliasses needs the same treatment as the other aliasses, otherwise looks fine. 
