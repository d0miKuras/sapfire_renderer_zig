const std = @import("std");
const SDL = @import("sdl2_vulkan");
// const SDL_VK = @import("sdl2_vulkan");
const vk = @import("vk.zig");

const BaseDispatch = vk.BaseWrapper(.{
    .createInstance = true,
});

const InstanceDispatch = vk.InstanceWrapper(.{ .destroy_instance = true });

const Renderer = struct { vkb: BaseDispatch = undefined, vki: InstanceDispatch = undefined };

pub fn main() !void {
    if (SDL.SDL_Init(SDL.SDL_INIT_VIDEO | SDL.SDL_INIT_EVENTS) < 0) {
        sdlPanic();
    }
    defer SDL.SDL_Quit();
    _ = SDL.SDL_Vulkan_LoadLibrary("");
    var window = SDL.SDL_CreateWindow("Sapfire Renderer", SDL.SDL_WINDOWPOS_CENTERED, SDL.SDL_WINDOWPOS_CENTERED, 800, 600, SDL.SDL_WINDOW_SHOWN | SDL.SDL_WINDOW_VULKAN) orelse sdlPanic();
    // var extension_count: u32 = 0;
    // SDL.SDL_Vulkan_GetInstanceExtensions(window, &extension_count, null);
    defer _ = SDL.SDL_DestroyWindow(window);
    // const vk_proc = @ptrCast(fn(instance: vk.Instance, procname: [*:0]const u8) callconv(.C) vk.PfnVoidFunction, sdl.)
    mainLoop: while (true) {
        var event: SDL.SDL_Event = undefined;
        while (SDL.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                SDL.SDL_QUIT => break :mainLoop,
                SDL.SDL_KEYDOWN => {
                    switch (event.key.keysym.scancode) {
                        SDL.SDL_SCANCODE_ESCAPE => break :mainLoop,
                        else => std.log.info("key pressed: {}\n", .{event.key.keysym.scancode}),
                    }
                },
                else => {},
            }
        }
    }
}

fn sdlPanic() noreturn {
    const str = @as(?[*:0]const u8, SDL.SDL_GetError()) orelse "Unknown Error";
    @panic(std.mem.sliceTo(str, 0));
}
