const std = @import("std");

const vk = @import("vulkan");
const zsdl3 = @import("zsdl3");

pub fn renderer() !void {
    std.debug.print("[VULKAN] module loaded, SDL_WINDOW_VULKAN flag: {d}\n", .{zsdl3.SDL_WINDOW_VULKAN});
    _ = vk;
}
