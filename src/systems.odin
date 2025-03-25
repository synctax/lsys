package main


make_koch_island :: proc(
) -> (
	system: ^LSystem(TurtleAlphabet),
	render_config: TurtleRenderConfig,
) {

	axiom := parse_turtle_word("F-F-F-F")
	defer delete(axiom)
	rule := parse_turtle_word("F−F+F+FF−F−F+F")
	defer delete(rule)

	productions := make_productions(TurtleAlphabet)
	add_production(&productions, TurtleAlphabet.STEP_DRAW, rule[:])

	sys := make_system(axiom[:], productions)

	config := TurtleRenderConfig {
		x     = 0,
		y     = 720 / 2,
		theta = deg_to_rad(90),
		d     = 10,
		a     = deg_to_rad(90),
	}
	return sys, config
}


make_plant1 :: proc() -> (system: ^LSystem(TurtleAlphabet), render_config: TurtleRenderConfig) {
	axiom := [?]TurtleAlphabet{.STEP_DRAW}
	rule := parse_turtle_word("FF-[-F+F+F]+[+F-F-F]")
	defer delete(rule)

	productions := make_productions(TurtleAlphabet)
	add_production(&productions, TurtleAlphabet.STEP_DRAW, rule[:])

	sys := make_system(axiom[:], productions)

	config := TurtleRenderConfig {
		x     = 1280 / 2,
		y     = 720,
		d     = 10,
		a     = deg_to_rad(22.5),
		theta = deg_to_rad(-90),
	}

	return sys, config
}
