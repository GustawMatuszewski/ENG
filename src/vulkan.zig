const std = @import("std");

const eng = @import("eng");

pub const VulkanRenderer = struct {
    instance: eng.c.VkInstance = null,
    surface: eng.c.VkSurfaceKHR = null,

    physical_device: eng.c.VkPhysicalDevice = null,
    indices: QueueFamilyIndices = .{},

    device: eng.c.VkDevice = null,
    graphics_queue: eng.c.VkQueue = null,
    present_queue: eng.c.VkQueue = null,
    compute_queue: eng.c.VkQueue = null,

    pub fn deinit(self: *VulkanRenderer) void {
        if (self.device != null) {
            eng.c.vkDestroyDevice(self.device, null);
            self.device = null;
        }

        self.graphics_queue = null;
        self.present_queue = null;
        self.compute_queue = null;

        if (self.surface != null) {
            eng.c.SDL_Vulkan_DestroySurface(
                self.instance,
                self.surface,
                null,
            );

            self.surface = null;
        }

        if (self.instance != null) {
            eng.c.vkDestroyInstance(self.instance, null);
            self.instance = null;
        }

        self.physical_device = null;
    }
};

const QueueFamilyIndices = struct {
    graphics: ?u32 = null,
    present: ?u32 = null,
    compute: ?u32 = null,
};

const PhysicalDeviceSelection = struct {
    device: eng.c.VkPhysicalDevice,
    indices: QueueFamilyIndices,
};

pub fn init(window: *eng.c.SDL_Window, allocator: std.mem.Allocator) !VulkanRenderer {
    eng.print_warning("VULKAN", "Trying to initialize vulkan...", .{});

    var renderer: VulkanRenderer = .{};
    errdefer renderer.deinit();

    renderer.instance = try createInstance();
    renderer.surface = try createSurface(window, renderer.instance);

    const physical_device: PhysicalDeviceSelection = try selectPhysicalDevice(renderer.instance, renderer.surface, allocator);

    renderer.physical_device = physical_device.device;
    renderer.indices = physical_device.indices;

    return renderer;
}

fn createInstance() !eng.c.VkInstance {
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
        eng.print_error("VULKAN", "failed to create instance", .{});
        return error.InstanceCreationFailed;
    }
    eng.print_success("VULKAN", "Vulkan instance created", .{});

    return instance;
}

fn createSurface(window: *eng.c.SDL_Window, instance: eng.c.VkInstance) !eng.c.VkSurfaceKHR {
    var surface: eng.c.VkSurfaceKHR = null;

    if (!eng.c.SDL_Vulkan_CreateSurface(
        window,
        instance,
        null,
        &surface,
    )) {
        eng.print_error("VULKAN", "Failed to create surface", .{});
        return error.SurfaceCreationFailed;
    }
    eng.print_success("VULKAN", "Vulkan surface was created", .{});
    return surface;
}

fn selectPhysicalDevice(instance: eng.c.VkInstance, surface: eng.c.VkSurfaceKHR, allocator: std.mem.Allocator) !PhysicalDeviceSelection {
    var pdev_count: u32 = 0;

    _ = eng.c.vkEnumeratePhysicalDevices(instance, &pdev_count, null);
    const physical_devices = try allocator.alloc(eng.c.VkPhysicalDevice, pdev_count);
    defer allocator.free(physical_devices);
    _ = eng.c.vkEnumeratePhysicalDevices(instance, &pdev_count, physical_devices.ptr);

    for (physical_devices) |device| {
        var props: eng.c.VkPhysicalDeviceProperties = undefined;
        eng.c.vkGetPhysicalDeviceProperties(device, &props);
        eng.print_info("VULKAN", "Physical device: {s}", .{std.mem.sliceTo(&props.deviceName, 0)});
        const indices = try inspectQueueFamilies(device, surface, allocator);
        const suitable = indices.graphics != null and indices.present != null and indices.compute != null;

        if (!suitable) {
            continue;
        }
        eng.print_info("VULKAN", "Found queues: graphics={?}, present={?}, compute={?}", .{
            indices.graphics,
            indices.present,
            indices.compute,
        });

        if (props.deviceType == eng.c.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU) {
            eng.print_success("VULKAN", "Selected: {s}", .{std.mem.sliceTo(&props.deviceName, 0)});
            return .{
                .device = device,
                .indices = indices,
            };
        }
    }

    eng.print_error("VULKAN", "No suitable physical device found", .{});
    return error.NoSuitableDevice;
}

fn inspectQueueFamilies(device: eng.c.VkPhysicalDevice, surface: eng.c.VkSurfaceKHR, allocator: std.mem.Allocator) !QueueFamilyIndices {
    var family_indices: QueueFamilyIndices = .{};
    var family_count: u32 = 0;
    eng.c.vkGetPhysicalDeviceQueueFamilyProperties(device, &family_count, null);

    const families = try allocator.alloc(eng.c.VkQueueFamilyProperties, family_count);
    defer allocator.free(families);

    eng.c.vkGetPhysicalDeviceQueueFamilyProperties(device, &family_count, families.ptr);

    for (families, 0..) |family, index| {
        const family_index: u32 = @intCast(index);
        var can_present: eng.c.VkBool32 = eng.c.VK_FALSE;

        const result = eng.c.vkGetPhysicalDeviceSurfaceSupportKHR(device, family_index, surface, &can_present);
        if (result != eng.c.VK_SUCCESS) {
            return error.PresentSupportQueryFailed;
        }

        if ((family.queueFlags & eng.c.VK_QUEUE_GRAPHICS_BIT) != 0) {
            family_indices.graphics = family_index;
        }

        if ((family.queueFlags & eng.c.VK_QUEUE_COMPUTE_BIT) != 0) {
            family_indices.compute = family_index;
        }

        if (can_present == eng.c.VK_TRUE) {
            family_indices.present = family_index;
        }
    }
    return family_indices;
}
