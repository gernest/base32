# base32

This implements `base32` `encoding` and `decoding` for the zig programming language (ziglang)

# Usage 

`example.zig`

```zig
const std = @import("std");
const warn = std.debug.warn;
const base32 = @import("src/base32.zig");

pub fn main() !void {
    var buf = &try std.Buffer.init(std.debug.global_allocator, "");
    defer buf.deinit();
    try encodeString(buf);
    try buf.resize(0);
    warn("\n\n");
    try decodeString(buf);
}

fn encodeString(buf: *std.Buffer) !void {
    const src = "any + old & data";
    const size = base32.std_encoding.encodeLen(src.len);
    try buf.resize(size);
    base32.std_encoding.encode(buf.toSlice(), src);
    warn("ExampleEncodingToString:\nsource: \"{}\"\noutput: {}\n", src, buf.toSlice());
}

fn decodeString(buf: *std.Buffer) !void {
    const src = "ONXW2ZJAMRQXIYJAO5UXI2BAAAQGC3TEEDX3XPY=";
    try base32.std_encoding.decode(buf, src);
    warn("ExampleDecodingString:\nsource: \"{}\"\noutput: {}\n", src, buf.toSlice());
}
```

```
$ zig run example.zig 
ExampleEncodingToString:
source: "any + old & data"
output: MFXHSIBLEBXWYZBAEYQGIYLUME======


ExampleDecodingString:
source: "ONXW2ZJAMRQXIYJAO5UXI2BAAAQGC3TEEDX3XPY="
output: some data with  and ﻿
```