const std = @import("std");

const app = @import("app.zig");
const eng = @import("eng");
pub fn main() !void {
    eng.print_warning("APP", "ENG is starting...", .{});

    app.run() catch |err| {
        eng.print_error("APP", "Unexpected crash occured ({any}) \n", .{err});
        return err;
    };

    eng.print_success("APP", "App has closed succesfully", .{});
}
