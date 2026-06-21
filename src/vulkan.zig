const std = @import("std");

const eng = @import("eng");

const candidate = struct {
    pdev: eng.c.VkPhysicalDevice,
    props: eng.c.VkPhysicalDeviceProperties,
    queues: struct {
        graphics_family: u32,
        present_family: u32,
        compute_family: u32,
    },
};

pub fn init(window: *eng.c.SDL_Window, allocator: std.mem.Allocator) !void {
    eng.print_warning("VULKAN", "Trying to initialize vulkan...", .{});

    const app_info: eng.c.VkApplicationInfo = .{
        .sType = eng.c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pNext = null,
        .pApplicationName = eng.app_name,
        .applicationVersion = @as(u32, @bitCast(eng.app_version)),
        .pEngineName = eng.app_name,
        .engineVersion = 0,
        .apiVersion = eng.c.VK_API_VERSION_1_3,
    };

    var ext_count: u32 = 0;
    const extensions = eng.c.SDL_Vulkan_GetInstanceExtensions(&ext_count);
    if (ext_count == 0) {
        eng.print_warning("SDL3", "SDL found 0 extensions for vulkan", .{});
    } else {
        if (extensions != null) {
            for (extensions[0..ext_count]) |ext| {
                eng.print_info("SDL3", "Extension: {s}", .{ext});
            }
        }
    }

    const create_info: eng.c.VkInstanceCreateInfo = .{
        .sType = eng.c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pNext = null,
        .flags = 0,
        .pApplicationInfo = &app_info,
        .enabledLayerCount = 0,
        .ppEnabledLayerNames = null,
        .enabledExtensionCount = ext_count,
        .ppEnabledExtensionNames = extensions,
    };

    var instance: eng.c.VkInstance = null;
    if (eng.c.vkCreateInstance(&create_info, null, &instance) != eng.c.VK_SUCCESS) {
        return error.InstanceCreationFailed;
    }

    var pdev_count: u32 = 0;
    _ = eng.c.vkEnumeratePhysicalDevices(instance, &pdev_count, null);
    const physical_devices = try allocator.alloc(eng.c.VkPhysicalDevice, pdev_count);
    defer allocator.free(physical_devices);
    _ = eng.c.vkEnumeratePhysicalDevices(instance, &pdev_count, physical_devices.ptr);

    var selected: ?candidate = null;
    for (physical_devices) |device| {
        var props: eng.c.VkPhysicalDeviceProperties = undefined;
        eng.c.vkGetPhysicalDeviceProperties(device, &props);
        eng.print_info("VULKAN", "Physical device: {s}", .{std.mem.sliceTo(&props.deviceName, 0)});
        if (props.deviceType == eng.c.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU) {
            selected = .{ .pdev = device, .props = props, .queues = undefined };
        }
    }

    if (selected) |dev| {
        eng.print_success("VULKAN", "Selected: {s}", .{std.mem.sliceTo(&dev.props.deviceName, 0)});
    } else {
        eng.print_error("VULKAN", "No suitable physical device found", .{});
        return error.NoSuitableDevice;
    }

    var surface: eng.c.VkSurfaceKHR = null;
    if (!eng.c.SDL_Vulkan_CreateSurface(window, instance, null, &surface)) {
        eng.print_error("VULKAN", "Failed to create surface", .{});
        return error.SurfaceCreationFailed;
    } else {
        eng.print_success("VULKAN", "Vulkan surface was created", .{});
    }

    var queue_family_count: u32 = 0;
    eng.c.vkGetPhysicalDeviceQueueFamilyProperties(selected.?.pdev, &queue_family_count, null);
    const queue_families = try allocator.alloc(eng.c.VkQueueFamilyProperties, queue_family_count);

    eng.c.vkGetPhysicalDeviceQueueFamilyProperties(selected.?.pdev, &queue_family_count, queue_families.ptr);
    defer allocator.free(queue_families);
}

pub fn renderer() !void {
    eng.print_success("VULKAN", "Module loaded, SDL_WINDOW_VULKAN flag: {d}\n", .{eng.c.SDL_WINDOW_VULKAN});
}
