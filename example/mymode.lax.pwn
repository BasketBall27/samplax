/*******************************************
*   Copyright (c) Laterium Contributors    *
*   ===================================    *
*   Laterium Project SA:MP PAWN/LAX 2.3    *
*   ===================================    *
********************************************/

#include "a_samp"

// This is a comment
// Uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
    print "\n--------------------------------------";
    print " Blank Filterscript by your name here";
    print "--------------------------------------\n";
    return 1;
}

public OnFilterScriptExit()
{
    return 1;
}

#else

main()
{
    print "\n----------------------------------";
    print " Blank Gamemode by your name here";
    print "----------------------------------\n";

    new a = 0, b = 0;

    if (a != b) {
        a = b;
    } else if (a == b) {
        printf "A is B!";
    }
}

#endif

Float:FindNearestPoint(Float:playerX, Float:playerY, Float:playerZ, Float:points[][3], count) {
    new Float:minDistance = 999999.9;
    new Float:currentDistance;

    for (new i = 0; i < count; i++) {
        currentDistance = floatsqroot(
            floatpower(playerX - points[i][0], 2) +
            floatpower(playerY - points[i][1], 2) +
            floatpower(playerZ - points[i][2], 2)
        );

        if (currentDistance < minDistance) {
            minDistance = currentDistance;
        }
    }

    return minDistance;
}

Rotate3D(Float:x, Float:y, Float:z, Float:angle, axis, &Float:newX, &Float:newY, &Float:newZ) {
    new Float:rad = angle * 3.14159 / 180.0;
    new Float:cosA = floatcos(rad, degrees);
    new Float:sinA = floatsin(rad, degrees);

    switch (axis) {
        case 0: {
            newY = y * cosA - z * sinA;
            newZ = y * sinA + z * cosA;
            newX = x;
        }
        case 1: {
            newX = x * cosA + z * sinA;
            newZ = -x * sinA + z * cosA;
            newY = y;
        }
        case 2: {
            newX = x * cosA - y * sinA;
            newY = x * sinA + y * cosA;
            newZ = z;
        }
    }
}

SinusoidalMovement(playerid, Float:amplitude, Float:frequency, Float:time, axis) {
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    new Float:offset = amplitude * floatsin(2.0 * 3.14159 * frequency * time);

    switch (axis) {
        case 0: pos[0] += offset;
        case 1: pos[1] += offset;
        case 2: pos[2] += offset;
    }

    SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
}

//////////////////////////////////////////
/////////// [global defines] /////////////
//////////////////////////////////////////
#define elif \
    else if
#define function%0(%1) \
    forward %0(%1); \
    public %0(%1)

new bool:playerIsDeath[MAX_PLAYERS];

public OnGameModeInit()
{
    // Don't use these lines if it's a filterscript
    SetGameModeText "Blank Script";
    AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

    CallLocalFunction("exOnGameModeInit", "d", playerid);

    return 1;
}

stock exOnGameModeInit(playerid)
{
    // Manual vehicle engine and lights
    ManualVehicleEngineAndLights();
    // Disable interior GTA SA original
    DisableInteriorEnterExits();

    return 1;
}

public OnGameModeExit()
{
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
    return 1;
}

public OnPlayerConnect(playerid)
{
    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));

    new fmt[200];
    format(fmt, sizeof(fmt), "%s Connected to the Server's", name);
    SendClientMessageToAll(-1, fmt);

    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if (playerIsDeath[playerid] == true) {
        // Do here..
        SendClientMessage(playerid, -1, "You have spawned after death!");

        playerIsDeath[playerid] = false;
    }
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if (playerIsDeath[playerid] != true) {
        playerIsDeath[playerid] = true;
    }
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if (strcmp(text, "mydog", true) == 0) {
        // Do something here
        return 0;
    }
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp("/mycommand", cmdtext, true, 10) == 0) {
        // Do something here
        return 1;
    }
    return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
    return 1;
}

public OnRconCommand(cmd[])
{
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    // Just use return 0 for player can't use spawn button..
    return 1;
}

public OnObjectMoved(objectid)
{
    return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    return 1;
}

public OnPlayerExitedMenu(playerid)
{
    return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    if (newinteriorid == oldinteriorid) {
        newinteriorid = 0;
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    return 1;
}

public OnPlayerUpdate(playerid)
{
    return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
    return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    new fmt[200];
    format(fmt, sizeof(fmt), "You clicked %d Player's", clickedplayerid);
    SendClientMessage(playerid, -1, fmt);

    return 1;
}
