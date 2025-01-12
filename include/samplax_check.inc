#include <a_samp>

#if !defined SendClientCheck
  native SendClientCheck(playerid, type, arg, offset, size);
#endif

forward OnClientCheckResponse(playerid, type, arg, response);

#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0
#define IsPlayerWindows(%0)                 GetPVarInt(%0, "NotLinux") == 0
#define IsPlayerLinux(%0)                   GetPVarInt(%0, "NotWindows") == 0

public OnPlayerConnect(playerid)
{
    SendClientCheck(playerid, 0x48, 0, 0, 2);
    SendClientCheck(playerid, 0x49, 0, 0, 2);
    #if defined L_OnPlayerConnect
        L_OnPlayerConnect(playerid);
    #endif
    return 1;
}

public OnClientCheckResponse(playerid, type, arg, response)
{
    switch(type)
    {       
        case 0x48:
        {
            SetPVarInt(playerid, "NotAndroid", 1);
        }
        case 0x49:
        {
            if(response == 1)
            {
                SetPVarInt(playerid, "NotLinux", 1);
            }
            else
            {
                SetPVarInt(playerid, "NotWindows", 1);
            }
        }
    }
    return 1;
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect L_OnPlayerConnect
#if defined L_OnPlayerConnect
    forward L_OnPlayerConnect(playerid);
#endif
