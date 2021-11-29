const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("base32", "src/base32.zig");
    lib.setBuildMode(mode);
    lib.install();

    const coverage = b.option(bool, "coverage", "Generate test coverage") orelse false;

    var main_tests = b.addTest("src/base32.zig");
    main_tests.setBuildMode(mode);

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
