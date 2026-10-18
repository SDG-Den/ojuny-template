# review 3

this review is done on a fresh install of ojuny via the setup script, this is a review of both for nix-settings-gui's custom modules for ojuny *and* for the template itself. 

the template repo owns ordering, what is visible, how things are named and how widgets are applied

the nix-settings-gui repo owns the shape of the custom ojuny widgets, the functions of the gui, rendering etc. 

the review is done by going through each page in nix-settings-gui on the test machine. 

# 01-Users

## user account

shell shouldn't be a raw, we could do with pkgs; to take pkgs out of the scope, and give a dropdown between zsh, bash, fish. 

also under Account (group name) it just lists "den", i don't know why, i'm guessing it's because the user description was set there too or this is the display of the account name (non-writeable)

> re-review note
suddenly this entire menu is gone?

## common settings

good

> re-review note

still good

# 02-Core

## display

icon is missing

monitors module looks pretty decent, but some items don't default sensibly, the add monitor prompt should be a pop-up that detects the monitor's name, refreshrate, width and height, prompting the user only to select one of their monitors, they can then position them interactively using the menu. the theming for this graphic is not correct and the x/y currently start at -16K when they should default to 0, scale should default to 1.00, RR should be called transform and should be based on the details from the actual mango config (~/repos/mango/docs)

monitors also need to snap to eachother when dragged around in the gui, and the canvas on which the monitors are dragged should be taller and be a different color to distinguish it, it should also always be the maximum width of the gui, not shrink if monitor positions allow it. 

saving with it and the gui updating when values are set via the toggles doesn't quite work correctly, things get desynced quite frequently.

we might also want to change out refresh, width and height to always be selectors with the selected monitor's reported refresh rate and resolution options. the user can then just select one of those which nix-settings-gui parses. 

current version also forces towards Y=-16K for some reason

> re-review note
icon is now here, defaults are good, no prompt to select for existing monitors as desired. add monitor should prompt with a pop-out that allows you to select an existing monitor, then select one of its available modes (use xrandr or wlr-randr or something similar?) which decides width, height and refresh. currently it always just defaults. the location defaults snapping is good and add works correctly (snaps to edge of existing monitor)

drag around works with setting values correctly in the gui, but works the wrong way around with snap, it currently only allows dragging *into* the boundary of the current monitor, as if they *have* to be touching, the snap should only be enforced when not dragging (so you can drag a monitor around another) and then snap when let go, always snapping to edge (so pushing out if overlapping)

gui also does not represent the transform, a 90deg transformed monitor still shows horizontal in the visual gui. 

## input

looks good

> re-review note

still looks good

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

> re-review note

popout now looks correct, except for missing an apply/cancel button pair at the bottom and some one-line descriptions, and preview is now correctly a preview, names however are still editable in the main menu when they should be the display names, not the raw names, and they should be labels like "Move Focus down:" without being editable. 

add/remove works as expected

maybe for visual clarity, add a decorative line between each entry? since the name labels won't have a box around them. 

## gestures

should be a set list of options for each available gesture in mango, with only an enable/disable toggle and the relevant command as fields (horizontal submodule)

> re-review note

i mean it should just present all the options mango gives for swipes generically, with the two-finger ones unset and the three-finger ones set the way we have by default, with each one being label + enable + command, potentially in a grid like binds, this might require a custom module? or table functionality might do in our case since it's just name, enable/disable, command.

## style

color palette is not using the custom module, looks like a simple text field now. 

stylix enable and theme mango from stylix settings should be hidden/advanced

gaps - individual gaps are still available even if set gaps per edge is disabled

set border thickness per surface - individual surfaces are still listed even with it disabled

shadows - settings are still shown with shadows disabled

animations - layer animations toggle and other opts should be below fade out. 

> re-review note

color palette says no schemes bundled when run with nix run, this should not be the case, this module needs to always work. 

gaps toggle now works, and is actually responsive (ui updates immediately) which is a win. 

rest of this page works great. 

## browser

looks good on firefox

switching to chrome - firefox is still visible, no chrome settings. 

> re-review note

when firefox is selected: firefox options available, looks good. chrome header below with no options, same for brave header, then defaultApplications, which should just be the toggle because browserDesktop does not resolve in the gui to the name, it just stays browserDesktop

when chrome or brave is selected: options are scarce, but looks fine, looks like the issue is just the group headers staying when the content is hidden. 

## git

packages should be advanced, git should not have an exposed toggle (always enabled)

> re-review note

looks good 

## terminal

needs a btop.enable so it gets stylix-themed, aliasses need to be turned into a table with an "add alias" button

> re-review note

aliases: looks messy because each table row is set size for the text (differs per row) and the toggle, then the text field takes up the rest. should probably be alligned (which might require changes to the table code)

the column headers at the top are also not really aligned because of this, they're *technically* aligned with one of the rows, but because every row differs it's not aligned with most rows

## startup

looks fine

> re-review note

still looks fine

## updates

looks fine

> re-review note

still fine

## nix settings

looks fine

> re-review note

still looks fine 

# 03-Desktop

## login

this entire file should be hidden menu.

> re-review note

is now hidden, good. 

## window management

looks fine, though special workspace dim should move to workspaces. 

> re-review note

done, good.

## master layout

im sure there are more master layout settings than this? double-check, otherwise looks fine

> re-review note

looks good 

## dwindle layout

there are more dwindle settings than this, and they should all be user-exposed, not hidden/advanced

> re-review note

looks good 

## scroller layout

looks good 

> re-review note

looks good

## workspaces

looks good

> re-review note

looks good

## notifications

clipboard is not related to notifications, should probably move to its own file.

> re-review note

there's some settings from DMS i remember here that should go in advanced settings, otherwise looks good. clipboard file also looks good

> follow-up (2026-10-18): confirmed against DMS `SettingsSpec.js` — the page
> exposes 7 of 26 notification settings; the 19 missing keys, their defaults
> and proposed grouping are listed in `review-3-issues.md` I13.
> (`notificationPopupPosition`, `notificationDedupeEnabled`,
> `notificationPopupBodyInvokesAction`, `notificationPopupShadowEnabled`,
> `notificationForegroundLayers`, `notificationTimeoutLow/Normal/Critical`,
> `notificationIgnoreAppTimeout`, `notificationDndWhileScreenSharing`,
> `notificationDndAllowCritical`, `notificationPopupPrivacyMode`,
> `notificationHistoryEnabled`, `notificationHistoryMaxAgeDays`,
> `notificationHistoryMaxCount`, `notificationHistorySaveLow/Normal/Critical`;
> the 26th, `notificationRules`, is a runtime rules list and stays
> DMS-managed.)

# 04-GUI

## bar

leftwidgets item is a *mess*. we have to completely redesign it, same for rightwidgets. 

furthermore, some settings that do not need to be shown to the user directly are here, and some should be put into horizontal submodules together. eg autohide and autohidedelay. 

also, the _order fields make zero sense and have zero explanation, nothing has any explanation here. 

> re-review note

better but still terrible, shape should be: for widgets, 3 lists with dragable tiles, each tile is a widget, the order they appear in the list is their position values in order, if a widget has extra settings, it has a little cog button on the tile that opens a pop-out with the settings. should have an add button that just allows you to pick from a list of widgets, so we need to prep presets for all available DMS bar widgets. we also need an "add custom" button for bar widgets we do not support. this also needs to be the case for center widgets (left, right and center actually use the same widgets, so any widget can be in any location, by default ojuny-template just doesn't use center widgets because it uses the island which disables them in favour of the island)

bar position still only has top/bottom listed when it also has left/right.


icon scale, font scale, spacing, bottom gap etc could be a horizontal submodule maybe? same for the various toggles below them.

border color should be a dropdown, same for all color options.

many of these need descriptions

goth corners have duplicated toggles (i think for two different things? need to be distinguished)



## dock

dock widgets module is... ok, but shouldn't use dock_launcher style names and _order will not make sense to the end user, nothing has descriptive names here.

same issues as bar 

> re-review note

same as bar for the widgets. 

under settings there's some things that need descriptions like smart auto hide. some things here should be fields (like max visible apps and max visible running apps).

ordering also doesnt quite make sense still, like why is show trash all the way at the bottom.

## launcher

fine

> re-review note

still fine

## dashboard

looks decent, except the col/row/w/h sections, we should turn those into tables, and allow the user to add/remove rows, this might need a custom module

> re-review state

actually, lets make a custom visual interface for these, so these each need a custom widget in nix-settings-gui, so this would be a grid with dragable, resizeable tiles that can be added from a list, selected item shows its settings in a pane below, and can be deleted from its details pane, resize can be done by dragging borders, which pushes other tiles if it can (cannot push beyind a fixed-width grid)

this also resolves the enable/disable and gives it the same shape as how it'd be configured in DMS directly

## control center

same as dashboard, but because the enable toggles are in here as well it's really messy. 

> re-review state

same as with the dashboard, re-design can take the same shape too.

## ojuny menu

extra plugin settings should be at the bottom, manage menu with nix is toggle-less and is a floating option, it should be removed (always enabled)

this module likewise needs a full rework. 

> re-review state

looks pretty good!

the edit menu is missing apply/cancel, and the popout needs to automatically grow in size to accomodate the advanced settings when popped out, this should also have some explanation in the descriptions. 

# 05-Applications

## installed applications

looks fine

> re-review note

still looks fine

## multimedia

looks mostly fine, though the 4 apps at the top have no descriptions

> re-review note

still no description for mpv, OBS, audacity and GIMP. 

## office

craftapps section is completely the wrong way around, it has the names editable, but the false : behind it without edits. 

opendocuments defaults should only be visible if libreoffice is enabled, it's currently disabled and they are still visible.

> re-review note

craftapps - same table allignment issue flagged earlier, because names are different length, enable switches and delete options are not alligned. 

## vesktop

likewise vesktop settings are visible with vesktop disabled, otherwise they look fine.

> re-review note

looks good 

## gaming

again, steam-related settings are shown even with steam disabled most likely. 

> re-review note

looks good

# 06-Utility

## web apps

works correctly! but the "webapps" title is shown twice, once with the description, and once more after. the labels for the columns are also not alligned. 

> re-review note

looks pretty good, labels are still not quite aligned, but i think this is once again down to the table alignment issue.

## DMS plugins

this module is a complete mess, it's a list of various raw option names (editable) with "add plugin" below, each list also has a toggle which are all set to false atm. needs a full rework

> re-review note

plugins should be selectable from a dropdown menu if possible with add plugin, and settings button should be a pop-out, we should also right-allign the delete and toggle, and have settings be right-aligned left of the toggle. this needs to be wrapped in a more top-level widget on the nix-settings-gui side

## phone connect

control center widget needs to be moved to control center with the rest of its modules, bar widget needs to be moved to bar widget setup. KDE connect toggle can move to applications, this menu can be deprecated

> re-review note

not here, so correct.

# 07-System

## system

text doesn't span the whole width for something like hostname, which has quite a large description. this causes the option menu to need scrolling for only 4 options. 

> re-review note

still the same issue. 

## networking

looks good

> re-review note

looks good

## bluetooth

looks good 

> re-review note

looks good

## graphics

shows all 3 vendors regardless, also unsure if options from other vendors are still applying with a specific vendor set, also "none" needs to be an option that applies no specific-vendor settings, only general ones.

> re-review note

same issue as browsers: groups with all members hidden still show their title, otherwise looks good. 

# patches

## development

aliasses needs the same treatment as the other aliasses, otherwise looks fine. 

> re-review note

same table alignment issue.

also, the add row functionality here is a bit broken, as it presents 3 fillable fields to the user, rather than a field, then a toggle, then another field. this also results in it being "true" rather than true in the nix file. 

