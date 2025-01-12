# Example
```pwn
#include "samplax"

main () {
  printf "Hello, World!";
}

public OnPlayerSpawn(playerid) {

  if (player.Connected(playerid)) {
    SendClientMessage playerid, -1, "Welcome!";
  }

  return 1;
}
```
