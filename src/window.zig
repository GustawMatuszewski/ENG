const std = @import("std");

const zsdl3 = @import("zsdl3");

const eng = @import("eng.zig");

pub fn init() !void {
    if (!zsdl3.init(zsdl3.SDL_INIT_VIDEO | zsdl3.SDL_INIT_AUDIO)) {
        eng.printError("WINDOW - SDL3", "Failed to initialize sdl3 ({s})", .{zsdl3.getError() orelse "unknown"});
        return error.SDLInitFailed;
    }
    eng.printSuccess("WINDOW - SDL3", "Initialized sdl3", .{});
}

pub fn create(title: [*:0]const u8, width: i32, height: i32) ?*zsdl3.SDL_Window {
    const window = zsdl3.createWindow(title, width, height, zsdl3.SDL_WINDOW_VULKAN);
    if (window == null) {
        eng.printError("WINDOW - SDL3", "Failed to create window '{s}' ({s})", .{ title, zsdl3.getError() orelse "unknown" });
    }
    eng.printSuccess("WINDOW - SDL3", "Window '{s}' created, w: {d}, h: {d}", .{ title, width, height });
    return window;
}
