```pwn
#include "samplax"

main () {}

public OnPlayerSpawn (playerid) {
  if (player.Connect(playerid)) {
    if (player.Android(playerid)) {
      SendClientMessage playerid, -1, "Android!";
    }
    else if (player.Windows(playerid)) {
      SendClientMessage playerid, -1, "Windows!";
    }
    else if (player.Linux(playerid)) {
      SendClientMessage playerid, -1, "Linux!";
    }
  }
  return 1;
}
```
