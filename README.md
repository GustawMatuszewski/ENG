# zigVulkan

A Zig + SDL3 + Vulkan project.

## Prerequisites

- Zig 0.15.2+
- CMake 3.16+
- Vulkan SDK
- A C compiler (gcc or clang)

### Gentoo
```bash
sudo emerge dev-lang/zig dev-util/cmake dev-util/vulkan-headers dev-util/vulkan-tools
```

### Arch
```bash
sudo pacman -S zig cmake vulkan-devel
```

### Ubuntu/Debian
```bash
sudo apt install cmake gcc vulkan-tools libvulkan-dev
# install zig manually from https://ziglang.org/download/
```

### Windows / macOS
- Install [Zig](https://ziglang.org/download/)
- Install [CMake](https://cmake.org/download/)
- Install [Vulkan SDK](https://vulkan.lunarg.com/)

## Clone

```bash
git clone --recurse-submodules https://github.com/yourusername/zigVulkan.git
cd zigVulkan
```

If you already cloned without `--recurse-submodules`:
```bash
git submodule update --init --recursive
```

## Build SDL3

```bash
cmake -S deps/SDL -B deps/SDL/build
cmake --build deps/SDL/build --parallel
cmake --install deps/SDL/build --prefix deps/SDL/out
```

## Build SDL3_image

```bash
cmake -S deps/SDL_image -B deps/SDL_image/build -DSDL3_DIR=deps/SDL/out/lib64/cmake/SDL3
cmake --build deps/SDL_image/build --parallel
cmake --install deps/SDL_image/build --prefix deps/SDL_image/out
```

## Run

```bash
zig build run
```

## Update dependencies

```bash
git submodule update --remote deps/SDL
git submodule update --remote deps/SDL_image
git submodule update --remote deps/zsdl3
```
