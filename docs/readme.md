# Example

<details>
  <summary>Click to see the script</summary>

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
