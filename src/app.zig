const std = @import("std");

const eng = @import("eng");
const window = @import("window.zig");
const vulkan = @import("vulkan.zig");

pub fn run() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();
    try window.init();
    defer eng.c.SDL_Quit();

    const mainWindow = try window.create("nygerion", 800, 800);
    defer eng.c.SDL_DestroyWindow(mainWindow);

    const renderer = try vulkan.init(mainWindow, allocator);
    _ = renderer;

    var running = true;
    while (running) {
        var event: eng.c.SDL_Event = undefined;
        while (eng.c.SDL_PollEvent(&event)) {
            switch (event.type) {
                eng.c.SDL_EVENT_QUIT => running = false,
                eng.c.SDL_EVENT_KEY_DOWN => {
                    if (event.key.scancode == eng.c.SDL_SCANCODE_ESCAPE) {
                        running = false;
                    }
                },
                else => {},
            }
        }
    }
    const bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
}
