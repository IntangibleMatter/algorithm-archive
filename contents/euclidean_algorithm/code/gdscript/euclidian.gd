extends Node

func _ready() -> void:
	print("[#]\nModulus-based euclidian algorithm result:")
	print(euclid_mod(64 * 67, 64 * 81))
	print("[#]\nSubtraction-based euclidian algorithm result:")
	print(euclid_sub(128 * 12, 128 * 77))

func euclid_mod(a: int, b: int) -> int:
	a = abs(a)
	b = abs(b)

	while b > 0:
		var c := b
		b = a % b
		a = c

	return a

func euclid_sub(a: int, b: int) -> int:
	a = abs(a)
	b = abs(b)

	if a == 0:
		return b
	elif b == 0:
		return a

	while a != b:
		if a > b:
			a -= b
		else:
			b -= a

	return a
