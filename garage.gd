extends Node3D
class_name VehicleGarage

var displayed_vehicle: Node3D
var selected_vehicle: Dictionary = {}

var dragging := false
var last_touch_x := 0.0
var rotation_speed := 0.012

func _ready() -> void:
    create_garage_floor()

func create_garage_floor() -> void:
    var floor := MeshInstance3D.new()
    var mesh := BoxMesh.new()

    mesh.size = Vector3(18, 0.3, 18)
    floor.mesh = mesh
    floor.position.y = -0.2

    var material := StandardMaterial3D.new()
    material.albedo_color = Color(0.20, 0.22, 0.26)
    floor.material_override = material

    add_child(floor)

func display_vehicle(data: Dictionary) -> void:
    if data.is_empty():
        return

    selected_vehicle = data

    if is_instance_valid(displayed_vehicle):
        displayed_vehicle.queue_free()

    displayed_vehicle = create_vehicle_model(data)
    add_child(displayed_vehicle)

func create_vehicle_model(data: Dictionary) -> Node3D:
    var vehicle := Node3D.new()

    var body := MeshInstance3D.new()
    var body_mesh := BoxMesh.new()

    var vehicle_type: String = data.get("type", "Car")

    if vehicle_type == "Microbus":
        body_mesh.size = Vector3(2.1, 1.5, 4.5)
    elif vehicle_type == "SUV":
        body_mesh.size = Vector3(2.2, 1.3, 4.3)
    else:
        body_mesh.size = Vector3(2.0, 0.8, 4.0)

    body.mesh = body_mesh
    body.position.y = 1.0

    var body_material := StandardMaterial3D.new()
    body_material.albedo_color = data.get(
        "color", Color.BLUE
    )
    body_material.roughness = 0.5

    body.material_override = body_material
    vehicle.add_child(body)

    var cabin := MeshInstance3D.new()
    var cabin_mesh := BoxMesh.new()

    cabin_mesh.size = Vector3(1.7, 0.9, 2.0)
    cabin.mesh = cabin_mesh
    cabin.position = Vector3(0, 2.0, -0.25)

    var glass_material := StandardMaterial3D.new()
    glass_material.albedo_color = Color(0.12, 0.32, 0.45)
    cabin.material_override = glass_material

    vehicle.add_child(cabin)

    for x in [-1.0, 1.0]:
        for z in [-1.35, 1.35]:
            var wheel := MeshInstance3D.new()
            var wheel_mesh := CylinderMesh.new()

            wheel_mesh.top_radius = 0.38
            wheel_mesh.bottom_radius = 0.38
            wheel_mesh.height = 0.25

            wheel.mesh = wheel_mesh
            wheel.rotation_degrees.z = 90
            wheel.position = Vector3(x, 0.45, z)

            var wheel_material := StandardMaterial3D.new()
            wheel_material.albedo_color = Color.BLACK
            wheel.material_override = wheel_material

            vehicle.add_child(wheel)

    return vehicle

func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        dragging = event.pressed
        last_touch_x = event.position.x

    elif event is InputEventScreenDrag and dragging:
        var difference: float = event.position.x - last_touch_x

        if is_instance_valid(displayed_vehicle):
            displayed_vehicle.rotate_y(
                difference * rotation_speed
            )

        last_touch_x = event.position.x

    elif event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            dragging = event.pressed
            last_touch_x = event.position.x

    elif event is InputEventMouseMotion and dragging:
        var difference: float = event.position.x - last_touch_x

        if is_instance_valid(displayed_vehicle):
            displayed_vehicle.rotate_y(
                difference * rotation_speed
            )

        last_touch_x = event.position.x
