const std = @import("std");
const zsdl3 = @import("zsdl3");

const window = @import("window.zig");

pub fn run() !void {
    try window.init();
    defer zsdl3.quit();

    const mainWindow = window.create("nygerion", 800, 800) orelse return error.SDLWindowFailed;
    defer zsdl3.destroyWindow(mainWindow);

    var running = true;
    while (running) {
        // Handle events
        var event: zsdl3.SDL_Event = undefined;
        while (zsdl3.pollEvent(&event)) {
            switch (event.type) {
                zsdl3.SDL_EVENT_QUIT => running = false,
                zsdl3.SDL_EVENT_KEY_DOWN => {
                    if (event.key.scancode == zsdl3.SDL_SCANCODE_ESCAPE) {
                        running = false;
                    }
                },
                else => {},
            }
        }
    }
}
