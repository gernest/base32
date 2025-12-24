const std = @import("std");
const base32 = @import("src/base32.zig");
var stdout_writer = std.fs.File.stdout().writer(&.{});
const stdout = &stdout_writer.interface;

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
    try stdout.print("ExampleEncodingToString:\nsource: \"{s}\"\noutput: {s}\n", .{ src, out });
}

fn decodeString() !void {
    const src = "ONXW2ZJAMRQXIYJAO5UXI2BAAAQGC3TEEDX3XPY=";
    const size = comptime base32.std_encoding.decodeLen(src.len);
    var buf: [size]u8 = undefined;
    const out = try base32.std_encoding.decode(&buf, src);
    try stdout.print("ExampleDecodingString:\nsource: {s}\noutput: \"{s}\"\n", .{ src, out });
}
