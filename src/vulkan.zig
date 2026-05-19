const std = @import("std");

const vk = @import("vulkan");
const zsdl3 = @import("zsdl3");
const eng = @import("eng.zig");

pub fn init() !void {
    eng.printWarning("VULKAN", "Trying to initialize vulkan...", .{});
    const app_info: vk.ApplicationInfo = .{
        .p_application_name = eng.appName,
        .application_version = eng.appVersion,
        .p_engine_name = eng.appName,
        .engine_version = 0,
        .api_version = @bitCast(vk.makeApiVersion(0, 1, 3, 0)),
    };

    const create_info: vk.InstanceCreateInfo = .{
        .flags = .{},
        .p_application_info = &app_info,
        .enabled_layer_count = 0,
        .pp_enabled_layer_names = undefined,
        .enabled_extension_count = 0,
        .pp_enabled_extension_names = undefined,
    };

    _ = create_info;
}

pub fn renderer() !void {
    eng.printSuccess("VULKAN", "Module loaded, SDL_WINDOW_VULKAN flag: {d}\n", .{zsdl3.SDL_WINDOW_VULKAN});
    _ = vk;
}
