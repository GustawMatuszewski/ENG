pub const packages = struct {
    pub const @"deps/SDL" = struct {
        pub const build_root = "/home/gustaw/zigVulkan/deps/SDL";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"zsdl3-0.0.0-l0pNpOzCBQC787su6DZEZd3CV67QK-_mCt5qOD1iewXz" = struct {
        pub const build_root = "/home/gustaw/.cache/zig/p/zsdl3-0.0.0-l0pNpOzCBQC787su6DZEZd3CV67QK-_mCt5qOD1iewXz";
        pub const build_zig = @import("zsdl3-0.0.0-l0pNpOzCBQC787su6DZEZd3CV67QK-_mCt5qOD1iewXz");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "sdl", "deps/SDL" },
    .{ "zsdl3", "zsdl3-0.0.0-l0pNpOzCBQC787su6DZEZd3CV67QK-_mCt5qOD1iewXz" },
};
