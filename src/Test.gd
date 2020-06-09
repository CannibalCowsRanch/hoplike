extends Node2D

onready var lava := $lava
onready var ground := $ground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var noise = OpenSimplexNoise.new()
	randomize()
	# Configure
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

	var map_radius := 3
	for q in range(-map_radius, map_radius+1):
		var r1 := max(-map_radius, -q - map_radius)
		var r2 := min(map_radius, -q + map_radius)
		for r in range(r1, r2+1):
			var coord := cube_to_oddq(Vector3(q, r, -q-r))
			$lava.set_cell(coord.x, coord.y, 1)
			var noisepix = noise.get_noise_2d(coord.x, coord.y)
			if noisepix > -0.1 and noisepix < 0.1:
				$ground.set_cell(coord.x, coord.y, 0)


func cube_to_oddq(cube: Vector3) -> Vector2:
	var col = cube.x
	var row = cube.z + (cube.x - (int(cube.x) & 1)) / 2
	return Vector2(col, row)


func oddq_to_cube(hex: Vector2) -> Vector3:
	var x = hex.x
	var z = hex.y - (hex.x - (int(hex.x) & 1)) / 2
	var y = -x-z
	return Vector3(x, y, z)
