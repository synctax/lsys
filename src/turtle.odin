package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

TurtleAlphabet :: enum {
	STEP,
	STEP_DRAW,
	RIGHT,
	LEFT,
	PUSH,
	POP,
}

parse_turtle_word :: proc(word: string) -> [dynamic]TurtleAlphabet {
	al: [dynamic]TurtleAlphabet
	for c in word {
		switch c {
		case 'f':
			append_elem(&al, TurtleAlphabet.STEP)
		case 'F':
			append_elem(&al, TurtleAlphabet.STEP_DRAW)
		case '-':
			append_elem(&al, TurtleAlphabet.RIGHT)
		case '+':
			append_elem(&al, TurtleAlphabet.LEFT)
		case '[':
			append_elem(&al, TurtleAlphabet.PUSH)
		case ']':
			append_elem(&al, TurtleAlphabet.POP)
		}
	}

	return al
}

TurtleRenderConfig :: struct {
	x, y, theta, d, a: f32,
}

@(private)
RenderState :: struct {
	x, y, theta: f32,
}

turtle_render :: proc(config: ^TurtleRenderConfig, state: [dynamic]TurtleAlphabet) {
	x, y, theta, d, a: f32 = config.x, config.y, config.theta, config.d, config.a

	state_stack: [dynamic]RenderState
	defer delete(state_stack)

	for letter in state {
		switch letter {
		case .STEP:
			x += d * math.cos(theta)
			y += d * math.sin(theta)
		case .STEP_DRAW:
			pX, pY := x, y
			x = x + (d * math.cos(theta))
			y = y + (d * math.sin(theta))
			rl.DrawLineEx(rl.Vector2{pX, pY}, rl.Vector2{x, y}, 2, rl.BLACK)
		case .RIGHT:
			theta += a
		case .LEFT:
			theta -= a
		case .PUSH:
			append(&state_stack, RenderState{x, y, theta})
		case .POP:
			popped := pop(&state_stack)
			x, y, theta = popped.x, popped.y, popped.theta
		}
	}

}
