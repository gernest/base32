# base32

This implements `base32` `encoding` and `decoding` for the zig programming language (ziglang)

# Installation 
First fetch dependency by running:
```
zig fetch --save git+https://github.com/gernest/base32
```
Then update your `build.zig` file to load the module:
```
const base32 = b.dependency("base32", .{});
exe.root_module.addImport("base32", base32.module("base32"));
```

# Usage 

`example.zig`

```zig
const std = @import("std");
const base32 = @import("src/base32.zig");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    try encodeString();
    try stdout.print("\n\n", .{});
    try decodeString();
}

fn encodeString() !void {
    const src = "any + old & data";
    const size = comptime base32.std_encoding.encodeLen(src.len);
    var buf: [size]u8 = undefined;
    const out = base32.std_encoding.encode(&buf, src);
    try stdout.print("ExampleEncodingToString:\nsource: \"{s}\"\noutput: {s}\n", .{src, out});
}

fn decodeString() !void {
    const src = "ONXW2ZJAMRQXIYJAO5UXI2BAAAQGC3TEEDX3XPY=";
    const size = comptime base32.std_encoding.decodeLen(src.len);
    var buf: [size]u8 = undefined;
    const out = try base32.std_encoding.decode(&buf, src);
    try stdout.print("ExampleDecodingString:\nsource: {s}\noutput: \"{s}\"\n", .{src, out});
}
```

```
$ zig run example.zig
ExampleEncodingToString:
source: "any + old & data"
output: MFXHSIBLEBXWYZBAEYQGIYLUME======


ExampleDecodingString:
source: ONXW2ZJAMRQXIYJAO5UXI2BAAAQGC3TEEDX3XPY=
output: "some data with  and ﻿"

```
