# Example
```pwn
#include "samplax"

main () {
  printf "Hello, World!";
}

public OnPlayerSpawn(playerid) {

  if (Player.Connected(playerid)) {
    SendClientMessage playerid, -1, "Welcome!";
  }

  return 1;
}
```
