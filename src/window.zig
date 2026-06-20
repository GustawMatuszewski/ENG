const std = @import("std");

const eng = @import("eng.zig");

pub fn init() !void {
    if (!eng.c.SDL_Init(eng.c.SDL_INIT_VIDEO | eng.c.SDL_INIT_AUDIO)) {
        eng.print_error("WINDOW - SDL3", "Failed to initialize sdl3 ({s})", .{eng.c.SDL_GetError()});
        return error.SDLInitFailed;
    }
    eng.print_success("WINDOW - SDL3", "Initialized sdl3", .{});
}

pub fn create(title: [*:0]const u8, width: i32, height: i32) !*eng.c.SDL_Window {
    const window = eng.c.SDL_CreateWindow(title, width, height, eng.c.SDL_WINDOW_VULKAN);
    if (window == null) {
        eng.print_error("WINDOW - SDL3", "Failed to create window '{s}' ({s})", .{ title, eng.c.SDL_GetError() });
        return error.SDLWindowFailed;
    }
    eng.print_success("WINDOW - SDL3", "Window '{s}' created, w: {d}, h: {d}", .{ title, width, height });
    return window.?;
}
