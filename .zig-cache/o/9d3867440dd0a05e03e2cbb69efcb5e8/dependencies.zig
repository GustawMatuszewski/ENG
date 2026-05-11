pub const packages = struct {
    pub const @"deps/SDL" = struct {
        pub const build_root = "/home/gustaw/zigVulkan/deps/SDL";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "sdl", "deps/SDL" },
};
