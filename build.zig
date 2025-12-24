const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/base32.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(
        .{
            .linkage = .static,
            .name = "base32",
            .root_module = lib_mod,
        },
    );

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);

    // This adds a module which allows it to be imported as module with Zon
    _ = b.addModule("base32", .{
        .root_source_file = b.path("src/base32.zig"),
    });

    const coverage = b.option(bool, "coverage", "Generate test coverage") orelse false;

    var main_tests = b.addTest(
        .{
            .root_module = lib_mod,
        },
    );

    const run_main_tests = b.addRunArtifact(main_tests);

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
    test_step.dependOn(&run_main_tests.step);
}
