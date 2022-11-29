#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <clientprefs>

bool g_bEnable[MAXPLAYERS + 1] = {false, ...};
ConVar g_cvChannel;
Handle g_hCookie = INVALID_HANDLE;

public Plugin myinfo =
{
	name = "Simple Speedometer",
	author = "Original by Cruze, modified by koen",
	description = "Simple speed display at the top-left corner",
	version = "1.4", // Code refactoring and optimization
	url = "https://github.com/notkoen"
}

public void OnPluginStart()
{
	g_cvChannel = CreateConVar("sm_speedometer_channel", "0", "game_text channel for speedometer to be displayed on", _, true, 0.0, true, 5.0);
	AutoExecConfig(true);
	
	RegConsoleCmd("sm_speed", Cmd_Speed, "Toggle speedometer display"); // It is recommended you comment this line out if you have ExtraCommands plugin from BotoX
	RegConsoleCmd("sm_speedmeter", Cmd_Speed, "Toggle speedometer display");
	RegConsoleCmd("sm_speedometer", Cmd_Speed, "Toggle speedometer display");
	
	SetCookieMenuItem(SettingsMenuHandler, INVALID_HANDLE, "Speedometer");

	g_hCookie = RegClientCookie("clientspeedcookie", "Speedometer cookie", CookieAccess_Private);
	
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client) && AreClientCookiesCached(client))
		{
			OnClientCookiesCached(client);
		}
	}
}

public void SettingsMenuHandler(int client, CookieMenuAction action, any info, char[] buffer, int maxlen)
{
	switch (action)
	{
		case CookieMenuAction_DisplayOption:
			Format(buffer, maxlen, "Speedometer: %s", g_bEnable[client] ? "On" : "Off");
		case CookieMenuAction_SelectOption:
		{
			ToggleSpeed(client);
			ShowCookieMenu(client);
		}
	}
}

public void ToggleSpeed(int client)
{
	g_bEnable[client] = !g_bEnable[client];
	PrintToChat(client, " \x04[SM] \x01You have %s \x01speed display.", g_bEnable[client] ? "\x04enabled" : "\x02disabled");
	SetClientCookie(client, g_hCookie, g_bEnable[client] ? "1" : "0");
}

public void OnClientCookiesCached(int client)
{
	char buffer[2];
	GetClientCookie(client, g_hCookie, buffer, sizeof(buffer));
	
	if (buffer[0] == '\0') return;
	g_bEnable[client] = StrEqual(buffer, "1");
}

public Action Cmd_Speed(int client, int args)
{
	if (client == 0) return Plugin_Handled;
	ToggleSpeed(client);
	return Plugin_Handled;
}

public void OnClientDisconnect(int client)
{
	g_bEnable[client] = false;
}

public void OnPlayerRunCmdPost(int client, int buttons, int impulse, const float vel[3], const float angles[3], int weapon, int subtype, int cmdnum, int tickcount, int seed, const int mouse[2]) 
{
	if (!IsClientInGame(client)) return;
	if (!g_bEnable[client]) return;
	
	float vVel[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
	float fVelocity = SquareRoot(Pow(vVel[0], 2.0) + Pow(vVel[1], 2.0));
	
	if (IsPlayerAlive(client))
	{
		SetHudTextParams(0.0, 0.0, 0.1, 255, 255, 255, 255, 0, 0.0, 0.0, 0.0); //Thanks tilgep for fixing fading in/out issue!
		ShowHudText(client, g_cvChannel.IntValue, "Speed: %.2f u/s", fVelocity);
		return;
	}
	
	if (IsClientObserver(client))
	{
		int SpecTarget = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
		if (SpecTarget < 1 || SpecTarget > MaxClients || !IsClientInGame(SpecTarget))
			return;
		
		char ClientName[32];
		GetClientName(SpecTarget, ClientName, 32);
		ShowHudText(client, g_cvChannel.IntValue, "%s's Speed: %.2f u/s", ClientName, fVelocity);
	}
}
