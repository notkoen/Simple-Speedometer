# Simple-Speedometer
A simple speedometer plugin made for the Zombie Escape game mode. Some players prefer seeing their own velocity when playing ZE to know if they're bhopping. However, Valve recently blocked the command `cl_showpos`, which meant players can no longer see their own velocity in game without `sv_cheats 1`. 

The goal of this plugin is to bring back the velocity display in a similar fashion as before.

# Features / Changes
- Speedometer is disabled by default *(Minimize chances of flickering due to limited channels)*
- Uses `DynamicChannels` to minimize flickering issues by allowing [Dynamic Channels](https://github.com/Vauff/DynamicChannels) plugin to do the channel assignment
- Config file allows for which `game_text` channel to use
- Location of speedometer is in the top left corner, similar to `cl_showpos` display
- Allows you to see the speed of the player you are spectating
- Uses `ShowHudText` instead of `ShowHintText` due to possible conflicts with Boss Hud plugins

# Credits and Thanks:
- This plugin is a fork of Cruze's [CSGO-Simple-SpeedoMeter](https://github.com/Cruze03/CSGO-Simple-SpeedoMeter)
- Vauff's [Dynamic Channels](https://github.com/Vauff/DynamicChannels) plugin
- [tilgep](https://steamcommunity.com/id/tilgep/) for assisting me with `SetHudTextParams` issue

# Change Logs
## Changes for 1.2 Version:
- Using `<csgocolors_fix>` instad of `<zipcore_csgocolors>`
- Removed PrintHintText option
- Removed the advert that tells players the command
- Force speedometer to be disabled by default
## Changes for 1.3 Version:
- Re-added spectate target speed display
- Changed the display to show "Speed: " so people are not confused
## Changes for 1.3.1 Version:
- Fix a stupid mistake in max allowed channel number for sm_speedometer_channel cvar
