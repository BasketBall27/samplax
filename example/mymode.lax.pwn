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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

SpiralUpwardMovement(objectid, Float:centerX, Float:centerY, Float:initialZ, Float:radius, Float:verticalSpeed, Float:time) {
    new Float:angle = time * 45.0;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);
    new Float:z = initialZ + verticalSpeed * time;

    SetObjectPos(objectid, x, y, z);
}

ProjectileTrajectory(Float:startX, Float:startY, Float:startZ, Float:velocity, Float:angle, Float:gravity, Float:time) {
    new Float:x = startX + velocity * time * floatcos(angle, degrees);
    new Float:y = startY + velocity * time * floatsin(angle, degrees);
    new Float:z = startZ + velocity * time * floatsin(angle, degrees) - 0.5 * gravity * time * time;

    CreateExplosion(x, y, z, 10, 1.0);
}

WaveMovement(objectid, Float:amplitude, Float:wavelength, Float:speed, Float:centerX, Float:centerY, Float:centerZ, Float:time) {
    new Float:x = centerX + wavelength * time;
    new Float:z = centerZ + amplitude * floatsin(speed * time, degrees);

    SetObjectPos(objectid, x, centerY, z);
}

EllipseMovement(objectid, Float:centerX, Float:centerY, Float:radiusX, Float:radiusY, Float:angleSpeed, Float:time) {
    new Float:angle = time * angleSpeed;
    new Float:x = centerX + radiusX * floatcos(angle, degrees);
    new Float:y = centerY + radiusY * floatsin(angle, degrees);

    SetObjectPos(objectid, x, y, centerY);
}

RandomizedMovement(objectid, Float:originX, Float:originY, Float:originZ, Float:maxRadius) {
    new Float:x = originX + floatrandom(maxRadius) - maxRadius / 2;
    new Float:y = originY + floatrandom(maxRadius) - maxRadius / 2;
    new Float:z = originZ + floatrandom(maxRadius) - maxRadius / 2;

    SetObjectPos(objectid, x, y, z);
}

Oscillate3D(objectid, Float:amplitudeX, Float:amplitudeY, Float:amplitudeZ, Float:frequency, Float:time) {
    new Float:xOffset = amplitudeX * floatsin(frequency * time, degrees);
    new Float:yOffset = amplitudeY * floatcos(frequency * time, degrees);
    new Float:zOffset = amplitudeZ * floatsin(frequency * time, degrees);

    new Float:x, Float:y, Float:z;
    GetObjectPos(objectid, x, y, z);
    SetObjectPos(objectid, x + xOffset, y + yOffset, z + zOffset);
}

FlowerExplosion(Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:time) {
    for (new i = 0; i < 360; i += 45) {
        new Float:angle = i + (floatsin(time, degrees) * 30.0);
        new Float:x = centerX + radius * floatcos(angle, degrees);
        new Float:y = centerY + radius * floatsin(angle, degrees);

        CreateExplosion(x, y, centerZ, 10, 1.0);
    }
}

LissajousCurve(objectid, Float:centerX, Float:centerY, Float:amplitudeX, Float:amplitudeY, Float:frequencyX, Float:frequencyY, Float:time) {
    new Float:x = centerX + amplitudeX * floatsin(frequencyX * time, degrees);
    new Float:y = centerY + amplitudeY * floatcos(frequencyY * time, degrees);

    SetObjectPos(objectid, x, y, centerY);
}

SpiralCamera(playerid, Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:heightSpeed, Float:time) {
    new Float:angle = time * 45.0;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);
    new Float:z = centerZ + heightSpeed * time;

    SetPlayerCameraPos(playerid, x, y, z);
    SetPlayerCameraLookAt(playerid, centerX, centerY, centerZ);
}

DynamicSpiralMovement(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:initialRadius, Float:radiusIncrement, Float:verticalSpeed, Float:time, Float:angularSpeed) {
    new Float:angle = angularSpeed * time;
    new Float:radius = initialRadius + radiusIncrement * time;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);
    new Float:z = centerZ + verticalSpeed * time;

    SetObjectPos(objectid, x, y, z);
}

RotateObjectIn3D(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:axisX, Float:axisY, Float:axisZ, Float:angle, Float:time) {
    new Float:radAngle = angle * (PI / 180.0);
    new Float:cosA = floatcos(radAngle);
    new Float:sinA = floatsin(radAngle);

    new Float:x, Float:y, Float:z;
    GetObjectPos(objectid, x, y, z);

    new Float:relX = x - centerX;
    new Float:relY = y - centerY;
    new Float:relZ = z - centerZ;

    new Float:newX = (cosA + (1.0 - cosA) * axisX * axisX) * relX +
                     ((1.0 - cosA) * axisX * axisY - sinA * axisZ) * relY +
                     ((1.0 - cosA) * axisX * axisZ + sinA * axisY) * relZ;

    new Float:newY = ((1.0 - cosA) * axisY * axisX + sinA * axisZ) * relX +
                     (cosA + (1.0 - cosA) * axisY * axisY) * relY +
                     ((1.0 - cosA) * axisY * axisZ - sinA * axisX) * relZ;

    new Float:newZ = ((1.0 - cosA) * axisZ * axisX - sinA * axisY) * relX +
                     ((1.0 - cosA) * axisZ * axisY + sinA * axisX) * relY +
                     (cosA + (1.0 - cosA) * axisZ * axisZ) * relZ;

    SetObjectPos(objectid, centerX + newX, centerY + newY, centerZ + newZ);
}

SimulateGravity(objects[], count, Float:timeStep, Float:gravitationalConstant) {
    for (new i = 0; i < count; i++) {
        new Float:x1, Float:y1, Float:z1;
        GetObjectPos(objects[i], x1, y1, z1);

        new Float:forceX = 0.0, Float:forceY = 0.0, Float:forceZ = 0.0;

        for (new j = 0; j < count; j++) {
            if (i == j) continue;

            new Float:x2, Float:y2, Float:z2;
            GetObjectPos(objects[j], x2, y2, z2);

            new Float:dx = x2 - x1;
            new Float:dy = y2 - y1;
            new Float:dz = z2 - z1;
            new Float:distance = floatsqroot(dx * dx + dy * dy + dz * dz);

            if (distance > 0.0) {
                new Float:force = gravitationalConstant / (distance * distance);
                forceX += force * (dx / distance);
                forceY += force * (dy / distance);
                forceZ += force * (dz / distance);
            }
        }

        new Float:newX = x1 + forceX * timeStep;
        new Float:newY = y1 + forceY * timeStep;
        new Float:newZ = z1 + forceZ * timeStep;

        SetObjectPos(objects[i], newX, newY, newZ);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

