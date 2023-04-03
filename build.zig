const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const lib = b.addStaticLibrary(
        .{
            .name = "base32",
            .root_source_file = .{ .path = "src/base32.zig" },
            .target = target,
            .optimize = optimize,
        },
    );
    lib.install();

    const coverage = b.option(bool, "coverage", "Generate test coverage") orelse false;

    var main_tests = b.addTest(
        .{
            .root_source_file = .{ .path = "src/base32.zig" },
            .optimize = optimize,
        },
    );

    if (coverage) {
        main_tests.setExecCmd(&[_]?[]const u8{
            "kcov",
            "--clean",
            "--include-path=./src/",
            "kcov-output",
            null, // to get zig to use the --test-cmd-bin flag
        });
    }

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
