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

//////////////////////////////////////////
/////////// [global floats] //////////////
//////////////////////////////////////////
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

Float:CalculateAngleBetweenPlayers(playerid1, playerid2) {
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    GetPlayerPos(playerid1, x1, y1, z1);
    GetPlayerPos(playerid2, x2, y2, z2);

    new Float:deltaX = x2 - x1;
    new Float:deltaY = y2 - y1;

    return atan2(deltaY, deltaX) * 180.0 / 3.14159;
}

SpiralMovement(playerid, Float:radius, Float:angularSpeed, Float:verticalSpeed, Float:time) {
    new Float:angle = angularSpeed * time;
    new Float:xOffset = radius * floatcos(angle, degrees);
    new Float:yOffset = radius * floatsin(angle, degrees);
    new Float:zOffset = verticalSpeed * time;

    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    SetPlayerPos(playerid, pos[0] + xOffset, pos[1] + yOffset, pos[2] + zOffset);
}

IsPlayerInBoundingBox(playerid, Float:minX, Float:minY, Float:minZ, Float:maxX, Float:maxY, Float:maxZ) {
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    if (pos[0] >= minX && pos[0] <= maxX &&
        pos[1] >= minY && pos[1] <= maxY &&
        pos[2] >= minZ && pos[2] <= maxZ) {
        return 1;
    }
    return 0;
}

CircularMovement(playerid, Float:radius, Float:speed, Float:time) {
    new Float:angle = speed * time;
    new Float:xOffset = radius * floatcos(angle, degrees);
    new Float:yOffset = radius * floatsin(angle, degrees);

    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    SetPlayerPos(playerid, pos[0] + xOffset, pos[1] + yOffset, pos[2]);
}

WaveExplosion(Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:amplitude, Float:frequency, Float:time) {
    for (new angle = 0; angle < 360; angle += 30) {
        new Float:rad = angle * 3.14159 / 180.0;
        new Float:x = centerX + radius * floatcos(rad, degrees);
        new Float:y = centerY + radius * floatsin(rad, degrees);
        new Float:z = centerZ + amplitude * floatsin(frequency * time + rad);

        CreateExplosion(x, y, z, 10, 1.0);
    }
}

ScalePlayerPosition(playerid, Float:scaleX, Float:scaleY, Float:scaleZ) {
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    pos[0] *= scaleX;
    pos[1] *= scaleY;
    pos[2] *= scaleZ;

    SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
}

Float:GetPointOn3DCircle(Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:angle, axis, &Float:x, &Float:y, &Float:z) {
    new Float:rad = angle * 3.14159 / 180.0;

    switch (axis) {
        case 0: {
            x = centerX;
            y = centerY + radius * floatcos(rad, degrees);
            z = centerZ + radius * floatsin(rad, degrees);
        }
        case 1: {
            x = centerX + radius * floatsin(rad, degrees);
            y = centerY;
            z = centerZ + radius * floatcos(rad, degrees);
        }
        case 2: {
            x = centerX + radius * floatcos(rad, degrees);
            y = centerY + radius * floatsin(rad, degrees);
            z = centerZ;
        }
    }
}

OscillatePlayer(playerid, Float:amplitude, Float:frequency, Float:time) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    Float:zOffset = amplitude * floatsin(frequency * time, degrees);
    SetPlayerPos(playerid, x, y, z + zOffset);
}

AdjustCameraHeight(playerid, Float:heightOffset) {
    new Float:pos[3], Float:lookAt[3];
    GetPlayerCameraPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerCameraLookAt(playerid, lookAt[0], lookAt[1], lookAt[2]);

    pos[2] += heightOffset;
    lookAt[2] += heightOffset;

    SetPlayerCameraPos(playerid, pos[0], pos[1], pos[2]);
    SetPlayerCameraLookAt(playerid, lookAt[0], lookAt[1], lookAt[2]);
}

StarExplosion(Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:time) {
    for (new i = 0; i < 5; i++) {
        new Float:angle1 = (72 * i) + (36 * floatsin(time, degrees));
        new Float:angle2 = angle1 + 144;

        new Float:x1 = centerX + radius * floatcos(angle1, degrees);
        new Float:y1 = centerY + radius * floatsin(angle1, degrees);

        new Float:x2 = centerX + radius * floatcos(angle2, degrees);
        new Float:y2 = centerY + radius * floatsin(angle2, degrees);

        CreateExplosion(x1, y1, centerZ, 10, 1.0);
        CreateExplosion(x2, y2, centerZ, 10, 1.0);
    }
}

MoveObjectInHelix(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:verticalSpeed, Float:time) {
    new Float:angle = time * 30.0;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);
    new Float:z = centerZ + verticalSpeed * time;

    SetObjectPos(objectid, x, y, z);
}

ParabolicMovement(playerid, Float:initialX, Float:initialY, Float:initialZ, Float:velocityX, Float:velocityY, Float:initialVelocityZ, Float:gravity, Float:time) {
    new Float:x = initialX + velocityX * time;
    new Float:y = initialY + velocityY * time;
    new Float:z = initialZ + initialVelocityZ * time - 0.5 * gravity * time * time;

    SetPlayerPos(playerid, x, y, z);
}

AnimatedCircularObject(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:initialRadius, Float:shrinkRate, Float:time) {
    new Float:radius = initialRadius - shrinkRate * time;
    if (radius < 0.0) return;

    new Float:angle = time * 45.0;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);

    SetObjectPos(objectid, x, y, centerZ);
}

ZigZagMovement(playerid, Float:amplitude, Float:speed, Float:time) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    Float:xOffset = amplitude * floatsin(speed * time, degrees);
    Float:yOffset = amplitude * floatcos(speed * time, degrees);

    SetPlayerPos(playerid, x + xOffset, y + yOffset, z);
}

Float:CalculateDistanceBetweenObjects(objectid1, objectid2) {
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    GetObjectPos(objectid1, x1, y1, z1);
    GetObjectPos(objectid2, x2, y2, z2);

    return floatsqroot((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnGameModeInit()
{
    // Don't use these lines if it's a filterscript
    SetGameModeText "Blank Script";
    AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

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
