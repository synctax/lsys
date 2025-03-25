package main

import "core:fmt"
import "core:math"
import "core:mem"
import rl "vendor:raylib"


main :: proc() {

	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)

	defer {
		if len(track.allocation_map) > 0 {
			for _, entry in track.allocation_map {
				fmt.eprintf("%v leaked %v bytes\n", entry.location, entry.size)
			}
		}
		mem.tracking_allocator_destroy(&track)
	}
	rl.InitWindow(1280, 720, "Game Window")

	sys, config := make_plant1()
	defer delete_system(sys)

	shouldStep := false

	rl.BeginDrawing()
	rl.ClearBackground(rl.WHITE)
	rl.EndDrawing()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		if shouldStep {
			step_system(sys, 1)
			shouldStep = false
		}
		turtle_render(&config, sys.state)
		rl.EndDrawing()

		if rl.GetCharPressed() != 0 {
			shouldStep = true
		}
	}

	rl.CloseWindow()
}
