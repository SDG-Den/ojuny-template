# review 5

this review was done after the review-4 rework. 

review is done on a separate device with a fresh install of ojuny by going through every page in nix-settings-menu, one page is one file, and feedback is per-page/file

this is both a review of the template and the repository nix-settings-gui in ~/repos, which actually owns review-4.

this round of reviews is done by a less-technical third party, and evaluated from a normal-user perspective.


# general:

move description to a "info" icon that can be clicked or viewed by hover. (contains desciption + imported from), should also exist on submodule options

submodule keys should show their own key on hover, not the parent submodule key

sliders recently got an only scroll once clicked-to-focus fix, this needs to be applied to anything else that uses scroll, so scroll by default will always scroll the page.

multiple things should trigger a page reload.



# users

## user page

isNormalUser should not be exposed in gui

## common settings

use system packages and per-user package install should not be exposed in gui

# core

## display

monitor module:

background should be based on the GTK theme, so should the highlight color

label escapes the monitor box under certain rotations

Name should be labeled "Display Name"

rename Extra rules to extra settings, fold-out should be a bit larger, especially the fold-out icon needs to be indicated better

add monitor > double-click should open the next pane, resolution is listed twice (once in the dropdown, once afterwards in text)



## input

keyboard layout should be titled "xkb layouts"

mouse sensitivity should be a slider

scroll method belongs under Trackpad only i think? mouse has no scroll method > trackpad scroll method duplicated



## keybinds

looks good

## gestures

3f swipes should have generic display names
gesture table shouldn't have add row button if possible.

## style

palette module: left side palettes box needs to be taller to match the height of the right box. 

icon theme - toggle shouldn't be exposed in gui

color modes - widget text style dropdown isn't alligned vertically for some reason, despite everything else with the same dropdown being alligned that way, making it look out of place. 

## browser



## git

## terminal

## startup

## updates

## nix settings



# desktop

## window management

## master layout

## dwindle layout

## scroller layout

## workspaces

## notifications

## clipboard


# GUI

## bar

## dock

## launcher

## dashboard

## control center

## ojuny menu



# applications

## installed applications

## multimedia

## office

## vesktop

## gaming


# utility

## web apps

## DMS plugins


# system

## system

## networking

## bluetooth

## graphics

## power

## lock screen


# patches

## development

## flatpak

## docker

## virtualization

## nix shell
