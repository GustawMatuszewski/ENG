const std = @import("std");

const vk = @import("vulkan");
const zsdl3 = @import("zsdl3");
const eng = @import("eng.zig");

pub fn renderer() !void {
    eng.printSuccess("VULKAN", "Module loaded, SDL_WINDOW_VULKAN flag: {d}\n", .{zsdl3.SDL_WINDOW_VULKAN});
    _ = vk;
}
