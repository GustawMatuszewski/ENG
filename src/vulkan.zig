const std = @import("std");
const c = @import("c");

const vk = @import("vulkan");

const eng = @import("eng.zig");

const BaseWrapper = vk.BaseWrapper;
const InstanceWrapper = vk.InstanceWrapper;
const DeviceWrapper = vk.DeviceWrapper;

const candidate = struct {
    pdev: vk.PhysicalDevice,
    props: vk.PhysicalDeviceProperties,
    queues: struct {
        graphics_family: u32,
        present_family: u32,
    },
};
pub fn init(window: *eng.sdl3.SDL_Window, allocator: std.mem.Allocator) !void {
    eng.print_warning("VULKAN", "Trying to initialize vulkan...", .{});
    //APPLICATION INFO CREATION
    const proc_addr = eng.sdl3.vulkanGetVkGetInstanceProcAddr() orelse return error.VulkanLoaderNotFound;
    const loader: vk.PfnGetInstanceProcAddr = @ptrCast(proc_addr);
    const vkb = BaseWrapper.load(loader);
    const app_info: vk.ApplicationInfo = .{
        .p_application_name = eng.app_name,
        .application_version = eng.app_version,
        .p_engine_name = eng.app_name,
        .engine_version = 0,
        .api_version = @bitCast(vk.makeApiVersion(0, 1, 3, 0)),
    };

    var ext_count: u32 = 0;
    const extensions = eng.sdl3.vulkanGetInstanceExtensions(&ext_count);
    if (ext_count == 0) {
        eng.print_warning("SDL3", "Zsdl3 found 0 extensions for vulkan", .{});
    } else {
        if (extensions) |exts| {
            for (exts[0..ext_count]) |ext| {
                eng.print_success("SDL3", "Extension: {s}", .{ext});
            }
        }
    }

    const create_info: vk.InstanceCreateInfo = .{
        .flags = .{},
        .p_application_info = &app_info,
        .enabled_layer_count = 0,
        .pp_enabled_layer_names = undefined,
        .enabled_extension_count = ext_count,
        .pp_enabled_extension_names = extensions,
    };

    //PHYSICAL DEVICE SELECTION
    const instance = try vkb.createInstance(&create_info, null);
    const vki = InstanceWrapper.load(instance, loader);

    var selected: ?candidate = null;
    const physical_devices = try vki.enumeratePhysicalDevicesAlloc(instance, allocator);
    defer allocator.free(physical_devices);
    for (physical_devices) |device| {
        const props = vki.getPhysicalDeviceProperties(device);
        eng.print_success("VULKAN", "Physical device: {s}", .{props.device_name});
        if (props.device_type == .discrete_gpu) {
            selected = .{ .pdev = device, .props = props, .queues = undefined };
        }
    }
    if (selected) |dev| {
        eng.print_success("VULKAN", "Selected: {s}", .{dev.props.device_name});
    } else {
        eng.print_error("VULKAN", "No suitable physical device found", .{});
        return error.NoSuitableDevice;
    }

    //SURFACE CREATION
    var surface: ?*anyopaque = null;
    if (!eng.sdl3.vulkanCreateSurface(window, @ptrFromInt(@intFromEnum(instance)), null, &surface)) {
        eng.print_error("VULKAN", "Failed to create VK surface", .{});
        return error.SurfaceCreationFailed;
    } else eng.print_success("VULKAN", "Vulkan surface was created", .{});

    //QUEUE FAMILIES
    const vkd = try allocator.create(DeviceWrapper);
    const queue_families = try vki.getPhysicalDeviceQueueFamilyPropertiesAlloc(selected.?.pdev, allocator);
    defer allocator.free(queue_families);
    _ = vkd;
    // const presentation_queue;
    //device.getPhysicalDeviceQueueFamilyProperties();
}
pub fn renderer() !void {
    eng.print_success("VULKAN", "Module loaded, SDL_WINDOW_VULKAN flag: {d}\n", .{eng.sdl3.SDL_WINDOW_VULKAN});
    _ = vk;
}
