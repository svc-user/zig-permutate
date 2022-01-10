const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const tests = b.addTest("src/permutate.zig");
    tests.setBuildMode(mode);
    tests.setTarget(target);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&tests.step);
}
