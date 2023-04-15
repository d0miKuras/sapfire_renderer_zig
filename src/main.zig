const std = @import("std");
const sdl = @import("sdl2");
const vk = @import("vulkan");

pub fn main() !void {
    try sdl.init(.{
        .video = true,
        .events = true,
    });
    defer sdl.quit();

    var window = try sdl.createWindow("Test window", .{.centered = {}}, .{.centered = {}}, 800, 600, .{.vis = .shown});
    defer window.destroy();

    mainLoop: while(true){
        while(sdl.pollEvent()) |ev|{
            switch(ev){
                .quit => break :mainLoop,
                .key_down => |key| {
                    switch(key.scancode){
                        .escape => break :mainLoop,
                        else => std.log.info("key pressed: {}\n", .{key.scancode})
                    }
                },
                else => {}
            }
        }
    }
}
