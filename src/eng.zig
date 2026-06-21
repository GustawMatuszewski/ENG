//This file is supposed to be a kind of library for the entire project.
//Any function or external librabry that will be used thruout the project should land here.

const std = @import("std");

pub const c = @cImport({
    @cInclude("SDL3/SDL.h");
    @cInclude("SDL3/SDL_vulkan.h");
    @cInclude("vulkan/vulkan.h");
});

pub const app_name = "ENG";
pub const app_version: i32 = 0;

pub fn print_success(section: []const u8, comptime fmt: []const u8, args: anytype) void {
    const message = std.fmt.allocPrint(std.heap.page_allocator, fmt, args) catch fmt;
    defer std.heap.page_allocator.free(message);
    std.debug.print("\x1b[42mSUCCESS\x1b[0m [{s}] - {s}\n", .{ section, message });
}

pub fn print_error(section: []const u8, comptime fmt: []const u8, args: anytype) void {
    const message = std.fmt.allocPrint(std.heap.page_allocator, fmt, args) catch fmt;
    defer std.heap.page_allocator.free(message);
    std.debug.print("\x1b[41mERROR\x1b[0m [{s}] - {s}\n", .{ section, message });
}

pub fn print_warning(section: []const u8, comptime fmt: []const u8, args: anytype) void {
    const message = std.fmt.allocPrint(std.heap.page_allocator, fmt, args) catch fmt;
    defer std.heap.page_allocator.free(message);
    std.debug.print("\x1b[43mWARNING\x1b[0m [{s}] - {s}\n", .{ section, message });
}

pub fn print_info(section: []const u8, comptime fmt: []const u8, args: anytype) void {
    const message = std.fmt.allocPrint(std.heap.page_allocator, fmt, args) catch fmt;
    defer std.heap.page_allocator.free(message);
    std.debug.print("\x1b[104mINFO\x1b[0m [{s}] - {s}\n", .{ section, message });
}
