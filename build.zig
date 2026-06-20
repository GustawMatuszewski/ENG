const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const vulkan_zig = b.dependency("vulkan_zig", .{});
    const vk_gen = vulkan_zig.artifact("vulkan-zig-generator");
    const vk_generate_cmd = b.addRunArtifact(vk_gen);
    vk_generate_cmd.addArg(b.pathFromRoot("deps/vulkan-zig/vk.xml"));
    const vulkan_module = vk_generate_cmd.addOutputFileArg("vk.zig");

    const mod = b.addModule("zig_vulkan", .{
        .link_libc = true,
        .imports = &.{
            .{ .name = "zsdl3", .module = b.dependency("zsdl3", .{}).module("zsdl3") },
            .{ .name = "vulkan", .module = b.createModule(.{ .root_source_file = vulkan_module }) },
        },
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

    mod.linkSystemLibrary("SDL3", .{});
    mod.addLibraryPath(b.path("deps/SDL/out/lib64"));
    mod.addLibraryPath(b.path("deps/SDL_image/out/lib64"));
    mod.addIncludePath(b.path("deps/SDL/include"));
    mod.addIncludePath(b.path("deps/SDL_image/include"));

    const exe = b.addExecutable(.{
        .name = "zig_vulkan",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "zig_vulkan", .module = mod },
                .{ .name = "zsdl3", .module = b.dependency("zsdl3", .{}).module("zsdl3") },
                .{ .name = "vulkan", .module = b.createModule(.{ .root_source_file = vulkan_module }) },
            },
        }),
    });

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });
    const run_mod_tests = b.addRunArtifact(mod_tests);

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
