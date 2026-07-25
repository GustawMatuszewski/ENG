# ENG
A Zig + SDL3 + Vulkan project.

This project targets Zig `0.16.0`. The repository includes a `.zigversion` file and VS Code settings so the official Zig extension can default to Zig `0.16.0` and ZLS automatically.

## Prerequisites
- Zig 0.16.0
- Vulkan SDK
- SDL3
- SDL3_image
- A C compiler (gcc or clang)
### Gentoo
```bash
sudo emerge dev-lang/zig media-libs/libsdl3 media-libs/sdl3-image dev-util/vulkan-headers dev-util/vulkan-tools
```
### Arch
```bash
sudo pacman -S zig sdl3 sdl3_image vulkan-devel
```
### Ubuntu/Debian
```bash
sudo apt install gcc vulkan-tools libvulkan-dev libsdl3-dev libsdl3-image-dev
# install zig manually from https://ziglang.org/download/
```
### Windows / macOS
- Install [Zig](https://ziglang.org/download/)
- Install [Vulkan SDK](https://vulkan.lunarg.com/)
- Install SDL3 and SDL3_image with your system package manager
## Clone
```bash
git clone --recurse-submodules https://github.com/GustawMatuszewski/ENG
cd ENG
```
If you already cloned without `--recurse-submodules`:
```bash
git submodule update --init --recursive
```
## Fetch Vulkan registry
```bash
curl -o deps/vulkan-zig/vk.xml \
  https://raw.githubusercontent.com/KhronosGroup/Vulkan-Docs/main/xml/vk.xml
```
## Run
```bash
zig build run
```
## Update dependencies
```bash
git submodule update --remote deps/vulkan-zig
```
