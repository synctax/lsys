package main

import "core:fmt"

LSystem :: struct($T: typeid) {
	state:       [dynamic]T,
	productions: map[T][]T,
}

make_system :: proc(axiom: $A/[]$L, productions: $P/map[L][]L) -> ^LSystem(L) {
	state := make([dynamic]L)
	for letter in axiom {
		append_elem(&state, letter)
	}
	sys := new(LSystem(L))
	sys.state = state
	sys.productions = productions
	return sys
}

delete_system :: proc(sys: ^LSystem($T)) {
	delete(sys.state)
	for _, succesor in sys.productions {
		delete_slice(succesor)
	}
	delete_map(sys.productions)
	free(sys)
}

make_productions :: proc($T: typeid) -> map[T][]T {
	return make_map(map[T][]T)
}

add_production :: proc(prod: ^$M/map[$T][]T, pred: T, suc: []T) {
	sucCopy := make_slice([]T, len(suc))
	copy_slice(sucCopy, suc)
	prod[pred] = sucCopy
}


step_system :: proc(sys: ^$T/LSystem($A), n: int) {
	for i in 0 ..< n {
		new := make_dynamic_array([dynamic]A)
		for l in sys.state {
			if suc, exists := sys.productions[l]; exists {
				for sucL in suc {
					append(&new, sucL)
				}
			} else {
				append(&new, l)
			}
		}
		delete(sys.state)
		sys.state = new
	}
}
