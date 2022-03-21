# Simple-Speedometer
A simple speedometer plugin made for the Zombie Escape game mode. Some players prefer seeing their own velocity when playing ZE to know if they're bhopping. However, Valve recently blocked the command `cl_showpos`, which meant players can no longer see their own velocity in game without `sv_cheats 1`. 

The goal of this plugin is to bring back the velocity display in a similar fashion as before.

# Features
- Speedometer is disabled by default *(Due to CSGO having 6 `game_text` channels, it is best to minimize channel usage to prevent flickering text due to conflicting channels)*
- Uses `DynamicChannels` to minimize flickering issues by allowing [Dynamic Channels](https://github.com/Vauff/DynamicChannels) plugin to do the channel assignment
- `game_text` channel is a ConVar that can be changed
- Location of speedometer is in the top left corner, similar to `cl_showpos` display
- Allows you to see the speed of the player you are spectating
- Uses `ShowHudText` *(game_text)* instead of `ShowHintText` due to possible conflicts with Boss Hud plugins

# Credits and Thanks:
- This plugin is a fork of Cruze's [CSGO-Simple-SpeedoMeter](https://github.com/Cruze03/CSGO-Simple-SpeedoMeter)
- Vauff's [Dynamic Channels](https://github.com/Vauff/DynamicChannels) plugin
- [tilgep](https://steamcommunity.com/id/tilgep/) for assisting me with `SetHudTextParams` issue
