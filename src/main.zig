const std = @import("std");

const app = @import("app.zig");

pub fn main() !void {
    std.debug.print("[APP] - App is starting...\n", .{});
    app.run() catch |err| {
        std.debug.print("[APP] ERROR - unexpected crash occurred: {any}\n", .{err});
        return err;
    };
    std.debug.print("[APP] - App is closed...\n", .{});
}
