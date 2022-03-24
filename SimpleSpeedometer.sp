#include <sourcemod>
#include <clientprefs>
#include <csgocolors_fix>
#include <DynamicChannels> //https://github.com/Vauff/DynamicChannels

#pragma semicolon 1
#pragma newdecls required

#define SERVER_TAG "{darkred}[{green}Speedometer{darkred}]"

bool g_bHideSpeedMeter[MAXPLAYERS + 1] = {false, ...};

ConVar g_cvar_SpeedometerChannel;

Handle g_hClientSpeedCookie = INVALID_HANDLE;

public Plugin myinfo = {
    name = "Simple Speedometer",
    author = "Cruze EDIT koen",
    description = "1.3.1",
    version = "",
    url = "https://github.com/Cruze03/CSGO-Simple-SpeedoMeter" //Original plugin by Cruze
}

public void OnPluginStart() {
    g_cvar_SpeedometerChannel = CreateConVar("sm_speedometer_channel", "0", "Which channel should speed be displayed on", _, true, 0.0, true, 5.0);
    AutoExecConfig(true, "speedometer");
    
    RegConsoleCmd("sm_speed", Toggle_Speed, "Toggle SpeedMeter");
    RegConsoleCmd("sm_speedmeter", Toggle_Speed, "Toggle SpeedMeter");
    RegConsoleCmd("sm_speedometer", Toggle_Speed, "Toggle SpeedMeter");
    
    g_hClientSpeedCookie = RegClientCookie("clientspeedcookie", "Cookie to check if speedmeter is blocked", CookieAccess_Private);
    
    for (int i = MaxClients; i > 0; --i) {
        if (!AreClientCookiesCached(i)) {
            continue;
        }
        OnClientCookiesCached(i);
    }
}

public Action Toggle_Speed(int client, int args) {
    g_bHideSpeedMeter[client] = !g_bHideSpeedMeter[client];
    
    if(g_bHideSpeedMeter[client]) {
        CPrintToChat(client, "%s {green} Enabled {default}Speed Meter.", SERVER_TAG);
        SetClientCookie(client, g_hClientSpeedCookie, "0");
    }
    else {
        CPrintToChat(client, "%s {red} Disabled {default}Speed Meter.", SERVER_TAG);
        SetClientCookie(client, g_hClientSpeedCookie, "1");
    }
    return Plugin_Handled;
}

public void OnClientCookiesCached(int client) {
    char sValue[8];
    GetClientCookie(client, g_hClientSpeedCookie, sValue, sizeof(sValue));
    
    g_bHideSpeedMeter[client] = (sValue[0] != '\0' && StringToInt(sValue));
}

public void OnClientDisconnect(int client) {
    g_bHideSpeedMeter[client] = false;
}

public void OnPlayerRunCmdPost(int client, int buttons, int impulse, const float vel[3], const float angles[3],
                               int weapon, int subtype, int cmdnum, int tickcount, int seed, const int mouse[2]) {
    if(IsValidClient(client) && g_bHideSpeedMeter[client]) {
        float vVel[3];
        GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
        float fVelocity = SquareRoot(Pow(vVel[0], 2.0) + Pow(vVel[1], 2.0));
        
        //Display speedometer in top left corner
        if(IsPlayerAlive(client)) {
            SetHudTextParams(0.0, 0.0, 0.1, 255, 255, 255, 255, 0, 0.0, 0.0, 0.0); //Thanks tilgep for fixing fading in/out issue!
            ShowHudText(client, GetDynamicChannel(g_cvar_SpeedometerChannel.IntValue), "Speed: %.2f u/s", fVelocity);
        }
        
        //Display speed of the spectate target
        if(IsClientObserver(client)) {
            int SpecTarget = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
            if(SpecTarget < 1 || SpecTarget > MaxClients || !IsClientInGame(SpecTarget))
                return;
            
            char ClientName[32];
            GetClientName(SpecTarget, ClientName, 32);
            ShowHudText(client, GetDynamicChannel(g_cvar_SpeedometerChannel.IntValue), "%s's Speed: %.2f u/s", ClientName, fVelocity);
        }
    }
}

//IsValidClient check
bool IsValidClient(int client, bool bAllowBots = true, bool bAllowDead = true) {
    if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bAllowDead && !IsPlayerAlive(client))) {
        return false;
    }
    return true;
}