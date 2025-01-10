#define ROTR(x, n) (((x) >> (n)) | ((x) << (64 - (n))) & 0xFFFFFFFFFFFFFFFF)

new const H[8] = {
    0x6A09E667F3BCC908, 0xBB67AE85A1D7A6E5, 0x3C6EF372FE94F82B, 0xA54FF53A5F1D36F1,
    0x510E527FADE682D1, 0x9B05688C2B3E6C1F, 0x1F83D9ABFB41BD6B, 0x5BE0CD19137E2179
};

stock SHA512(input[]) {
    new len = strlen(input);
    new data[128];
    new W[80];
    new a, b, c, d, e, f, g, h, k, temp1, temp2;
    new Htemp[8];
    memcpy(Htemp, H, sizeof(Htemp));

    // Preprocessing (Padding)
    memcpy(data, input, len);
    data[len] = 0x80; // Append 1 bit
    for (new i = len + 1; i < 112; i++) data[i] = 0;
    new bit_len = len * 8;
    new bit_len_high = bit_len >> 64;
    new bit_len_low = bit_len & 0xFFFFFFFFFFFFFFFF;
    data[120] = bit_len_high >> 56;
    data[121] = bit_len_high >> 48;
    data[122] = bit_len_high >> 40;
    data[123] = bit_len_high >> 32;
    data[124] = bit_len_high >> 24;
    data[125] = bit_len_high >> 16;
    data[126] = bit_len_high >> 8;
    data[127] = bit_len_high;

    // Process the message in 1024-bit chunks
    for (new i = 0; i < 16; i++)
        W[i] = (data[i * 8] << 56) | (data[i * 8 + 1] << 48) | (data[i * 8 + 2] << 40) |
               (data[i * 8 + 3] << 32) | (data[i * 8 + 4] << 24) | (data[i * 8 + 5] << 16) |
               (data[i * 8 + 6] << 8) | (data[i * 8 + 7]);
    for (new i = 16; i < 80; i++)
        W[i] = (ROTR(W[i - 2], 19) ^ ROTR(W[i - 2], 61) ^ (W[i - 2] >> 6)) + W[i - 7] + 
               (ROTR(W[i - 15], 1) ^ ROTR(W[i - 15], 8) ^ (W[i - 15] >> 7)) + W[i - 16];

    // Initialize working variables
    a = Htemp[0];
    b = Htemp[1];
    c = Htemp[2];
    d = Htemp[3];
    e = Htemp[4];
    f = Htemp[5];
    g = Htemp[6];
    h = Htemp[7];

    // Main loop
    for (new i = 0; i < 80; i++) {
        k = (i < 20) ? 0x428A2F98D728AE22 :
            (i < 40) ? 0x7137449123EF65CD :
            (i < 60) ? 0xB5C0FBCFBCF89B1D :
                       0xC67178F2E372532B;

        temp1 = h + (ROTR(e, 14) ^ ROTR(e, 18) ^ ROTR(e, 41)) + ((e & f) ^ (~e & g)) + k + W[i];
        temp2 = (ROTR(a, 28) ^ ROTR(a, 34) ^ ROTR(a, 39)) + ((a & b) ^ (a & c) ^ (b & c));

        h = g;
        g = f;
        f = e;
        e = d + temp1;
        d = c;
        c = b;
        b = a;
        a = temp1 + temp2;
    }

    // Add this chunk's hash to the result
    Htemp[0] = (Htemp[0] + a) & 0xFFFFFFFFFFFFFFFF;
    Htemp[1] = (Htemp[1] + b) & 0xFFFFFFFFFFFFFFFF;
    Htemp[2] = (Htemp[2] + c) & 0xFFFFFFFFFFFFFFFF;
    Htemp[3] = (Htemp[3] + d) & 0xFFFFFFFFFFFFFFFF;
    Htemp[4] = (Htemp[4] + e) & 0xFFFFFFFFFFFFFFFF;
    Htemp[5] = (Htemp[5] + f) & 0xFFFFFFFFFFFFFFFF;
    Htemp[6] = (Htemp[6] + g) & 0xFFFFFFFFFFFFFFFF;
    Htemp[7] = (Htemp[7] + h) & 0xFFFFFFFFFFFFFFFF;

    // Produce the final hash value as a string
    new result[129], offset = 0;
    for (new i = 0; i < 8; i++)
        offset += format(result[offset], 129 - offset, "%016llx", Htemp[i]);
    return result;
}
