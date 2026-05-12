const std = @import("std");
const zsdl3 = @import("zsdl3");

pub fn init() !void {
    if (!zsdl3.init(zsdl3.SDL_INIT_VIDEO | zsdl3.SDL_INIT_AUDIO)) {
        const err = zsdl3.getError();
        std.debug.print("[WINDOW - SDL3] ERROR - Failed to initialize sdl3. ({any})\n", .{err});
        return error.SDLInitFailed;
    }
    std.debug.print("[WINDOW - SDL3] SUCCESS - Initialized with sdl3.\n", .{});
}

pub fn create(title: [*:0]const u8, width: i32, height: i32) ?*zsdl3.SDL_Window {
    const window = zsdl3.createWindow(title, width, height, zsdl3.SDL_WINDOW_VULKAN);
    if (window == null) {
        const err = zsdl3.getError();
        std.debug.print("[WINDOW - SDL3] ERROR - Failed to create sdl3 window '{s}'. ({any})\n", .{ title, err });
    }
    std.debug.print("[WINDOW - SDL3] SUCCESS - Window '{s}' created, w: {d}, h: {d}\n", .{ title, width, height });
    return window;
}
