# manual review 2

review is done on a secondary laptop device running ojuny, review is done by evaluating the gui in system-only mode without advanced/hidden features shown.

generally: ordering is very off, and some options are weird/have the wrong setting method. ordering is also off in grouping of menus.

new functionality is also provided by nix-settings-gui to improve things.

# applications

## installed applications
good

## browser
mime toggle should not be here, since if it is off, default applications settings do not work. this should just be hard-on

firefox addons should also be here.

enable firefox toggle is just called firefox, should be enable firefox. 

better: should provide options between chrome, firefox, brave, maybe something else? instead of firefox toggle > dropdown selector, selected browser settings are shown, defaults to firefox.

## git
ordering is off

delta decorations should be a list of presets/options, not freeform

pager should be a list of options, not freeform

## multimedia

enable toggles should be organized as a horizontal submodule or using a table. 


## office

enable toggles should be organized as a horizontal submodule or using a table

## vesktop

enable toggle should be at the top.

## gaming

steam enable should be at the top. 

## terminal

ordering

history size should be a field, not a slider

toggles for zsh and ghostty should not exist, as they are intrinsic to the OS

## webapps

should be re-done as a table in gui

# desktop

## login

this page is empty.

## window management

master layout should be split to its own page (same for dwindle, which is still missing), workspaces settings as well. tag count should be a field, not a slider. master count should be a dropdown with options 1-5, not a slider. 

## scroller layout

many things here need a description, side structs should be a field, single window proportion should be a field, default proportion should be a field

## display

replace monitor rules with display module

## input

hide cursor after should be a field, not a slider

repeat delay and repeat rate should be a field, not a slider

drag tile to tile name is wrong, its functon is "tiled windows re-tile on drag-and-drop"


## style

ordering/grouping feels very random

gaps show all settings even with set gaps per edge being turned off, should only show the toggle and gap size normally. 



## bar

ordering, again. square corners setting seems inverted (listed as on, but corners are round).

widget sections should use custom functionality from nix-settings-gui

bar position 0/1 is not correct, it can be on the sides as well, and should be a left/right/top/bottom dropdown. 



## dock

no issues outside of ordering

## launcher

no issues

## dashboard

cards column/row/height/width should all use new custom functionality from nix-settings-gui


## control center

cards column/row/height/width should all use new custom functionality from nix-settings-gui

## notifications

many of these should be fields, not sliders

also, ordering is very off

## menu

needs to use custom functionality from nix-settings-gui

## plugins

needs to use custom functionality from nix-settings-gui

## phone connect

needs to use custom functionality from nix-settings-gui, 

## keybinds

needs to use custom functionality from nix-settings-gui, needs to make use of nested submodules, also needs to be moved to where each bind uses a horizontal submodule for modifiers + key

## gestures

not sure how but this needs to be much cleaner GUI-wise. maybe just hardcode all the swipes and only let the user change the action?

## startup

good

# system

## system

good

## networking

good

## bluetooth

good

## graphics

should be a dropdown at the top for vendor (intel/amd/nvidia), then only shows/enables the relevant options.

## nix settings

ordering, otherwise fine. 

## updates

nix-settings-gui should not have a toggle.

nom's enable name is wrong (name for the option can be "use nix-output-monitor for build graphing")

also, flake URI should be set during setup, same for clone path. setup also should pre-generate the settings for nix-settings-gui (which are not set through nix) with terminal command `ghostty -e zsh -c` and rebuild command `sudo echo "starting rebuild"; sudo nixos-rebuild boot --flake <repodir>#<configured hostname> |& nom` 

# users

## user account

looks fine

## common settings

looks fine