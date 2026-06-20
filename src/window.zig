const std = @import("std");

const eng = @import("eng.zig");

pub fn init() !void {
    if (!eng.sdl3.SDL_Init(eng.sdl3.SDL_INIT_VIDEO | eng.sdl3.SDL_INIT_AUDIO)) {
        eng.print_error("WINDOW - SDL3", "Failed to initialize sdl3 ({s})", .{eng.sdl3.SDL_GetError()});
        return error.SDLInitFailed;
    }
    eng.print_success("WINDOW - SDL3", "Initialized sdl3", .{});
}

pub fn create(title: [*:0]const u8, width: i32, height: i32) !*eng.sdl3.SDL_Window {
    const window = eng.sdl3.SDL_CreateWindow(title, width, height, eng.sdl3.SDL_WINDOW_VULKAN);
    if (window == null) {
        eng.print_error("WINDOW - SDL3", "Failed to create window '{s}' ({s})", .{ title, eng.sdl3.SDL_GetError() });
        return error.SDLWindowFailed;
    }
    eng.print_success("WINDOW - SDL3", "Window '{s}' created, w: {d}, h: {d}", .{ title, width, height });
    return window.?;
}
