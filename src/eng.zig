const std = @import("std");

pub fn printSuccess(section: []const u8, comptime fmt: []const u8, args: anytype) void {
    const message = std.fmt.allocPrint(std.heap.page_allocator, fmt, args) catch fmt;
    defer std.heap.page_allocator.free(message);
    std.debug.print("[{s}] \x1b[42m SUCCESS \x1b[0m - {s}\n", .{ section, message });
}

pub fn printError(section: []const u8, comptime fmt: []const u8, args: anytype) void {
    const message = std.fmt.allocPrint(std.heap.page_allocator, fmt, args) catch fmt;
    defer std.heap.page_allocator.free(message);
    std.debug.print("[{s}] \x1b[41m ERROR \x1b[0m - {s}\n", .{ section, message });
}

pub fn printWarning(section: []const u8, comptime fmt: []const u8, args: anytype) void {
    const message = std.fmt.allocPrint(std.heap.page_allocator, fmt, args) catch fmt;
    defer std.heap.page_allocator.free(message);
    std.debug.print("[{s}] \x1b[43m WARNING! \x1b[0m - {s}\n", .{ section, message });
}
