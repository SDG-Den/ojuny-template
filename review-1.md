# manual review done after phase1 commit by opening the repo in nix-settings-gui and evaluating the non-hidden, non-advanced options. options that are conditionally visible and not visible by default are not evaluated. 

installed applications - fine

browser - missing settings relating to extensions and profiles. 

git - missing actual username/token fields (idk if token is a smart idea, but something like a pointer to a credential file would be a good move)

office suite - i believe the core craftapps toggle doesnt install anything, just enables installing everything? so it should just be toggled on under the hood if any craft app is installed. check the craftapps flake docs. libreoffice - hope this has additional settings once toggled on

vesktop - hope there are additional settings once toggled on

gaming - windows compatibility tools toggle needs a description, and if possible, we should see if more configuration can be done here (eg steam/proton/wine config)

terminal - aliasses should be moved here. 

web apps - add youtube by default

window management - is missing a lot of settings that should be exposed to the user by default, for example, where are the scroller settings? these may also need to be split into a separate file

gestures - should have a settings menu for them, with a snippet to add them, and basic 3-finger-swipe left/right for workspace next/prev, down for launcher and up for menu

launcher - plugin triggers should move here

dashboard - missing positional configuration for the 3 things that have that. i'm missing config for those entirely. 

control center - again, missing positional configuration for the actual control center popout

menu - should show the whole existing settings block if possible

plugins - should have the current plugins listed. 

keybinds - dispatcher, arguments and description are *still* all visible, they should not be visible for all the builtins, only for ones added by the user.

startup - are all the things in here empty?

gpu - this needs to be reworked into a toggle between nvidia, amd and intel GPU, each with their own set of options that only show on that setting

nix settings - missing a lot of general settings for nix/nixd

user - default user should not be called den, mutable users should not be in this file

common settings - shell config should go under terminal



