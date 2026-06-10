
float readChannel(int channel) {
    return decodeColor(texelFetch(DataSampler, ivec2(4, channel), 0));
}

float readTime(int channel) {
    return decodeColor(texelFetch(DataSampler, ivec2(1, channel), 0));
}
