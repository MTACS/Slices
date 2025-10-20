# Slices
WIP View hierarchy viewer for macOS, requires [ammonia](https://github.com/CoreBedtime/ammonia) injection

<img width="1352" height="878" alt="slices" src="https://github.com/user-attachments/assets/65c0af68-1680-46b0-a531-829fee797b43" />

# Install

Clone this repo and move `release/Slices.app` to wherever you want, move `libSlices.dylib, libSlices.whitelist, and libSlices.blacklist` to `/private/var/ammonia/core/tweaks`. Use the Slices app to select which apps to inject into. Hierarchy window should appear when app is restarted, or can be opened via the menu item in the app's main menu. Note not all apps work and may crash on launch.

Uses [libMAList](https://github.com/jslegendre/libMAList) to grab list of installed apps
