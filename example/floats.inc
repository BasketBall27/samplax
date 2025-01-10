stock Rotate3D(Float:x, Float:y, Float:z, Float:angle, axis, &Float:newX, &Float:newY, &Float:newZ) {
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

stock Float:CalculateAngleBetweenPlayers(playerid1, playerid2) {
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    GetPlayerPos(playerid1, x1, y1, z1);
    GetPlayerPos(playerid2, x2, y2, z2);

    new Float:deltaX = x2 - x1;
    new Float:deltaY = y2 - y1;

    return atan2(deltaY, deltaX) * 180.0 / 3.14159;
}

stock IsPlayerInBoundingBox(playerid, Float:minX, Float:minY, Float:minZ, Float:maxX, Float:maxY, Float:maxZ) {
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    if (pos[0] >= minX && pos[0] <= maxX &&
        pos[1] >= minY && pos[1] <= maxY &&
        pos[2] >= minZ && pos[2] <= maxZ) {
        return 1;
    }
    return 0;
}

stock ScalePlayerPosition(playerid, Float:scaleX, Float:scaleY, Float:scaleZ) {
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    pos[0] *= scaleX;
    pos[1] *= scaleY;
    pos[2] *= scaleZ;

    SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
}

stock Float:GetPointOn3DCircle(Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:angle, axis, &Float:x, &Float:y, &Float:z) {
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

stock OscillatePlayer(playerid, Float:amplitude, Float:frequency, Float:time) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    Float:zOffset = amplitude * floatsin(frequency * time, degrees);
    SetPlayerPos(playerid, x, y, z + zOffset);
}

stock AdjustCameraHeight(playerid, Float:heightOffset) {
    new Float:pos[3], Float:lookAt[3];
    GetPlayerCameraPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerCameraLookAt(playerid, lookAt[0], lookAt[1], lookAt[2]);

    pos[2] += heightOffset;
    lookAt[2] += heightOffset;

    SetPlayerCameraPos(playerid, pos[0], pos[1], pos[2]);
    SetPlayerCameraLookAt(playerid, lookAt[0], lookAt[1], lookAt[2]);
}

stock MoveObjectInHelix(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:verticalSpeed, Float:time) {
    new Float:angle = time * 30.0;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);
    new Float:z = centerZ + verticalSpeed * time;

    SetObjectPos(objectid, x, y, z);
}

stock AnimatedCircularObject(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:initialRadius, Float:shrinkRate, Float:time) {
    new Float:radius = initialRadius - shrinkRate * time;
    if (radius < 0.0) return;

    new Float:angle = time * 45.0;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);

    SetObjectPos(objectid, x, y, centerZ);
}

stock Float:CalculateDistanceBetweenObjects(objectid1, objectid2) {
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    GetObjectPos(objectid1, x1, y1, z1);
    GetObjectPos(objectid2, x2, y2, z2);

    return floatsqroot((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1));
}

stock SpiralUpwardMovement(objectid, Float:centerX, Float:centerY, Float:initialZ, Float:radius, Float:verticalSpeed, Float:time) {
    new Float:angle = time * 45.0;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);
    new Float:z = initialZ + verticalSpeed * time;

    SetObjectPos(objectid, x, y, z);
}

stock Oscillate3D(objectid, Float:amplitudeX, Float:amplitudeY, Float:amplitudeZ, Float:frequency, Float:time) {
    new Float:xOffset = amplitudeX * floatsin(frequency * time, degrees);
    new Float:yOffset = amplitudeY * floatcos(frequency * time, degrees);
    new Float:zOffset = amplitudeZ * floatsin(frequency * time, degrees);

    new Float:x, Float:y, Float:z;
    GetObjectPos(objectid, x, y, z);
    SetObjectPos(objectid, x + xOffset, y + yOffset, z + zOffset);
}

stock LissajousCurve(objectid, Float:centerX, Float:centerY, Float:amplitudeX, Float:amplitudeY, Float:frequencyX, Float:frequencyY, Float:time) {
    new Float:x = centerX + amplitudeX * floatsin(frequencyX * time, degrees);
    new Float:y = centerY + amplitudeY * floatcos(frequencyY * time, degrees);

    SetObjectPos(objectid, x, y, centerY);
}

stock SpiralCamera(playerid, Float:centerX, Float:centerY, Float:centerZ, Float:radius, Float:heightSpeed, Float:time) {
    new Float:angle = time * 45.0;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);
    new Float:z = centerZ + heightSpeed * time;

    SetPlayerCameraPos(playerid, x, y, z);
    SetPlayerCameraLookAt(playerid, centerX, centerY, centerZ);
}

stock DynamicSpiralMovement(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:initialRadius, Float:radiusIncrement, Float:verticalSpeed, Float:time, Float:angularSpeed) {
    new Float:angle = angularSpeed * time;
    new Float:radius = initialRadius + radiusIncrement * time;
    new Float:x = centerX + radius * floatcos(angle, degrees);
    new Float:y = centerY + radius * floatsin(angle, degrees);
    new Float:z = centerZ + verticalSpeed * time;

    SetObjectPos(objectid, x, y, z);
}

stock RotateObjectIn3D(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:axisX, Float:axisY, Float:axisZ, Float:angle, Float:time) {
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

stock SimulateWaterWave(objectid, Float:centerX, Float:centerY, Float:baseZ, Float:amplitude, Float:wavelength, Float:speed, Float:time) {
    new Float:x, Float:y, Float:z;
    GetObjectPos(objectid, x, y, z);

    new Float:wave = amplitude * floatsin((x - centerX) / wavelength + speed * time, degrees) +
                     amplitude * floatsin((y - centerY) / wavelength + speed * time, degrees);

    SetObjectPos(objectid, x, y, baseZ + wave);
}

stock SimulateGravity(objects[], count, Float:timeStep, Float:gravitationalConstant) {
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

stock TorusPath(objectid, Float:centerX, Float:centerY, Float:centerZ, Float:majorRadius, Float:minorRadius, Float:rotationSpeed, Float:time) {
    new Float:theta = rotationSpeed * time;
    new Float:phi = rotationSpeed * time / 2.0;

    new Float:x = centerX + (majorRadius + minorRadius * floatcos(phi, degrees)) * floatcos(theta, degrees);
    new Float:y = centerY + (majorRadius + minorRadius * floatcos(phi, degrees)) * floatsin(theta, degrees);
    new Float:z = centerZ + minorRadius * floatsin(phi, degrees);

    SetObjectPos(objectid, x, y, z);
}
