const std = @import("std");

const app = @import("app.zig");
const eng = @import("eng.zig");
pub fn main() !void {
    eng.printWarning("APP", "ENG is starting...", .{});

    app.run() catch |err| {
        eng.printError("APP", "Unexpected crash occured ({any}) \n", .{err});
        return err;
    };

    eng.printSuccess("APP", "App has closed succesfully", .{});
}
