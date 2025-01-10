#define ROTL(x, n) (((x) << (n)) | ((x) >> (32 - (n))))

new const T[4] = {0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476};

stock MD5(input[]) {
    new len = strlen(input);
    new data[64], W[16], a, b, c, d, f, k, temp;
    new Ttemp[4];
    memcpy(Ttemp, T, sizeof(Ttemp));

    // Preprocessing (Padding)
    memcpy(data, input, len);
    data[len] = 0x80;  // Append 1 bit
    for (new i = len + 1; i < 56; i++) data[i] = 0;  // Pad with zeros
    new bit_len = len * 8;
    for (new i = 0; i < 8; i++) data[63 - i] = (bit_len >> (8 * i)) & 0xFF;  // Append length in bits

    // Initialize W from data (message schedule)
    for (new i = 0; i < 16; i++) {
        W[i] = (data[i * 4] << 24) | (data[i * 4 + 1] << 16) | 
               (data[i * 4 + 2] << 8) | (data[i * 4 + 3]);
    }

    // Main loop - Process the message in blocks of 512 bits
    a = Ttemp[0];
    b = Ttemp[1];
    c = Ttemp[2];
    d = Ttemp[3];

    for (new i = 0; i < 64; i++) {
        if (i < 16) {
            f = (b & c) | (~b & d);  // F
            k = 0xD76AA478;  // Constants
        } else if (i < 32) {
            f = (d & b) | (~d & c);  // G
            k = 0xE8C7B756;  // Constants
        } else if (i < 48) {
            f = b ^ c ^ d;  // H
            k = 0x242070DB;  // Constants
        } else {
            f = c ^ (b | ~d);  // I
            k = 0xC1BDCEEE;  // Constants
        }

        // MD5 core operation
        temp = ROTL(a, 5) + f + e + k + W[i % 16];
        e = d;
        d = c;
        c = ROTL(b, 30);
        b = a;
        a = temp;
    }

    // Add this chunk's hash to the result
    Ttemp[0] += a;
    Ttemp[1] += b;
    Ttemp[2] += c;
    Ttemp[3] += d;

    // Output final hash (concatenating results to form the 128-bit MD5 hash)
    new result[33], offset = 0;
    for (new i = 0; i < 4; i++) {
        offset += format(result[offset], 33 - offset, "%08x", Ttemp[i]);
    }
    return result;
}
