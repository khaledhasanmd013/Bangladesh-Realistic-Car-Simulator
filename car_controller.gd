
extends CharacterBody3D
class_name CarController

const MAX_SPEED := 38.0
const REVERSE_SPEED := 9.0
const ACCELERATION := 13.0
const BRAKE_POWER := 25.0
const FRICTION := 5.0
const TURN_RATE := 1.25

var speed := 0.0
var throttle_input := false
var brake_input := false
var steering_input := 0.0

var gear_system: GearSystem
var vehicle_camera: VehicleCameraController
var speed_label: Label

func _ready() -> void:
    gear_system = GearSystem.new()
    create_vehicle()
    create_camera()

func create_vehicle() -> void:
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()

    shape.size = Vector3(2.0, 1.4, 4.2)
    collision.shape = shape
    collision.position.y = 0.8
    add_child(collision)

    add_box(
        Vector3(2.0, 0.8, 4.2),
        Vector3(0, 0.8, 0),
        Color(0.05, 0.35, 0.85)
    )

    add_box(
        Vector3(1.7, 0.85, 1.9),
        Vector3(0, 1.55, -0.25),
        Color(0.15, 0.4, 0.58)
    )

    for x in [-1.0, 1.0]:
        for z in [-1.35, 1.35]:
            var wheel := MeshInstance3D.new()
            var mesh := CylinderMesh.new()

            mesh.top_radius = 0.38
            mesh.bottom_radius = 0.38
            mesh.height = 0.25

            wheel.mesh = mesh
            wheel.position = Vector3(x, 0.4, z)
            wheel.rotation_degrees.z = 90

            var material := StandardMaterial3D.new()
            material.albedo_color = Color.BLACK
            wheel.material_override = material

            add_child(wheel)

func add_box(
    size: Vector3,
    position: Vector3,
    color: Color
) -> void:
    var object := MeshInstance3D.new()
    var mesh := BoxMesh.new()

    mesh.size = size
    object.mesh = mesh
    object.position = position

    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.5

    object.material_override = material
    add_child(object)

func create_camera() -> void:
    vehicle_camera = VehicleCameraController.new()
    add_child(vehicle_camera)

func _physics_process(delta: float) -> void:
    update_speed(delta)
    update_steering(delta)
    update_movement()

func update_speed(delta: float) -> void:
    if not gear_system.can_move():
        speed = move_toward(speed, 0.0, BRAKE_POWER * delta)
        return

    var direction := gear_system.get_direction()

    if throttle_input:
        if direction > 0:
            speed += ACCELERATION * delta
        elif direction < 0:
            speed -= ACCELERATION * delta

    elif brake_input:
        speed = move_toward(
            speed,
            0.0,
            BRAKE_POWER * delta
        )

    else:
        speed = move_toward(
            speed,
            0.0,
            FRICTION * delta
        )

    speed = clampf(
        speed,
        -REVERSE_SPEED,
        MAX_SPEED
    )

func update_steering(delta: float) -> void:
    if abs(speed) < 0.1:
        return

    rotate_y(
        -steering_input *
        TURN_RATE *
        delta *
        sign(speed)
    )

func update_movement() -> void:
    var forward := -global_transform.basis.z

    velocity.x = forward.x * speed
    velocity.z = forward.z * speed
    velocity.y -= 20.0 * get_physics_process_delta_time()

    move_and_slide()

func set_throttle(value: bool) -> void:
    throttle_input = value

func set_brake(value: bool) -> void:
    brake_input = value

func set_steering(value: float) -> void:
    steering_input = clampf(value, -1.0, 1.0)

func change_camera() -> void:
    vehicle_camera.next_camera()

func toggle_gear_mode() -> void:
    gear_system.toggle_mode()

func shift_gear_up() -> void:
    if gear_system.mode == GearSystem.Mode.AUTOMATIC:
        gear_system.shift_automatic()
    else:
        gear_system.shift_manual_up()

func shift_gear_down() -> void:
    if gear_system.mode == GearSystem.Mode.MANUAL:
        gear_system.shift_manual_down()

func get_speed_kmh() -> int:
    return int(abs(speed) * 3.6)

func get_current_gear() -> String:
    return gear_system.get_gear_name()
