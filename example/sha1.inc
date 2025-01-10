#define ROTL(x, n) (((x) << (n)) | ((x) >> (32 - (n))))

// Initial hash values for SHA-1
new const H[5] = {
    0x67452301,
    0xEFCDAB89,
    0x98BADCFE,
    0x10325476,
    0xC3D2E1F0
};

stock SHA1(input[]) {
    new len = strlen(input);
    new data[64];
    new W[80];
    new a, b, c, d, e, f, k, temp;
    new Htemp[5];
    memcpy(Htemp, H, sizeof(Htemp));

    // Preprocessing (Padding)
    memcpy(data, input, len);
    data[len] = 0x80; // Append 1 bit
    for (new i = len + 1; i < 56; i++) data[i] = 0; // Fill with 0x00 until 56th byte
    new bit_len = len * 8; // Length in bits
    for (new i = 0; i < 8; i++) data[63 - i] = (bit_len >> (8 * i)) & 0xFF; // Append the bit length in the last 8 bytes

    // Process the message in 512-bit chunks
    for (new i = 0; i < 16; i++) {
        W[i] = (data[i * 4] << 24) | (data[i * 4 + 1] << 16) | (data[i * 4 + 2] << 8) | (data[i * 4 + 3]);
    }
    
    // Expanding the W array (80 words)
    for (new i = 16; i < 80; i++) {
        W[i] = ROTL(W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16], 1);
    }

    // Initialize working variables
    a = Htemp[0];
    b = Htemp[1];
    c = Htemp[2];
    d = Htemp[3];
    e = Htemp[4];

    // Main loop
    for (new i = 0; i < 80; i++) {
        if (i < 20) {
            f = (b & c) | ((~b) & d);
            k = 0x5A827999; // Constants for the first 20 iterations
        } else if (i < 40) {
            f = b ^ c ^ d;
            k = 0x6ED9EBA1; // Constants for the next 20 iterations
        } else if (i < 60) {
            f = (b & c) | (b & d) | (c & d);
            k = 0x8F1BBCDC; // Constants for the next 20 iterations
        } else {
            f = b ^ c ^ d;
            k = 0xCA62C1D6; // Constants for the last 20 iterations
        }

        temp = (ROTL(a, 5) + f + e + k + W[i]) & 0xFFFFFFFF;
        e = d;
        d = c;
        c = ROTL(b, 30);
        b = a;
        a = temp;
    }

    // Add this chunk's hash to the result
    Htemp[0] = (Htemp[0] + a) & 0xFFFFFFFF;
    Htemp[1] = (Htemp[1] + b) & 0xFFFFFFFF;
    Htemp[2] = (Htemp[2] + c) & 0xFFFFFFFF;
    Htemp[3] = (Htemp[3] + d) & 0xFFFFFFFF;
    Htemp[4] = (Htemp[4] + e) & 0xFFFFFFFF;

    // Produce the final hash value as a string
    new result[41], offset = 0;
    for (new i = 0; i < 5; i++) {
        offset += format(result[offset], 41 - offset, "%08x", Htemp[i]);
    }
    return result;
}
