
extends Node3D

# Bangladesh Realistic Car Simulator
# Main game and garage foundation

var selected_car: int = 0
var car_display: Node3D
var info_label: Label
var car_title: Label

var vehicle_names: Array[String] = [
    "Bangladesh Microbus",
    "Sports Car",
    "SUV"
]

var vehicle_colors: Array[Color] = [
    Color(0.08, 0.35, 0.85),
    Color(0.85, 0.12, 0.08),
    Color(0.12, 0.55, 0.25)
]

func _ready() -> void:
    create_environment()
    create_garage()
    create_interface()
    select_vehicle(0)

func create_environment() -> void:
    var world_environment := WorldEnvironment.new()
    var environment := Environment.new()

    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color(0.12, 0.16, 0.23)
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.75, 0.78, 0.85)
    environment.ambient_light_energy = 0.8

    world_environment.environment = environment
    add_child(world_environment)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-45, -30, 0)
    sun.light_energy = 1.3
    add_child(sun)

    var camera := Camera3D.new()
    camera.position = Vector3(0, 3.5, 9)
    camera.look_at(Vector3(0, 1, 0))
    camera.current = true
    add_child(camera)

func create_garage() -> void:
    var floor := MeshInstance3D.new()
    var floor_mesh := BoxMesh.new()

    floor_mesh.size = Vector3(18, 0.3, 18)
    floor.mesh = floor_mesh
    floor.position.y = -0.2
    floor.material_override = create_material(
        Color(0.22, 0.24, 0.28)
    )
    add_child(floor)

    var back_wall := MeshInstance3D.new()
    var wall_mesh := BoxMesh.new()

    wall_mesh.size = Vector3(18, 8, 0.3)
    back_wall.mesh = wall_mesh
    back_wall.position = Vector3(0, 3.8, -7)
    back_wall.material_override = create_material(
        Color(0.12, 0.16, 0.22)
    )
    add_child(back_wall)

    car_display = Node3D.new()
    add_child(car_display)

func create_interface() -> void:
    var canvas := CanvasLayer.new()
    add_child(canvas)

    var title := Label.new()
    title.text = "BANGLADESH REALISTIC CAR SIMULATOR"
    title.position = Vector2(20, 15)
    title.add_theme_font_size_override("font_size", 25)
    title.add_theme_color_override(
        "font_color", Color.WHITE
    )
    canvas.add_child(title)

    var menu := VBoxContainer.new()
    menu.position = Vector2(25, 95)
    menu.add_theme_constant_override("separation", 10)
    canvas.add_child(menu)

    add_menu_button(menu, "PLAY", start_game)
    add_menu_button(menu, "GARAGE", open_garage)
    add_menu_button(menu, "NEXT VEHICLE", next_vehicle)
    add_menu_button(menu, "PREVIOUS VEHICLE", previous_vehicle)
    add_menu_button(menu, "SETTINGS", open_settings)

    car_title = Label.new()
    car_title.position = Vector2(290, 410)
    car_title.add_theme_font_size_override("font_size", 25)
    car_title.add_theme_color_override(
        "font_color", Color.WHITE
    )
    canvas.add_child(car_title)

    info_label = Label.new()
    info_label.position = Vector2(25, 475)
    info_label.add_theme_font_size_override("font_size", 17)
    info_label.add_theme_color_override(
        "font_color", Color.WHITE
    )
    canvas.add_child(info_label)

    info_label.text = "Welcome to Bangladesh!"

func add_menu_button(
    parent: VBoxContainer,
    button_text: String,
    callback: Callable
) -> void:
    var button := Button.new()
    button.text = button_text
    button.custom_minimum_size = Vector2(190, 48)
    button.add_theme_font_size_override("font_size", 18)
    button.pressed.connect(callback)
    parent.add_child(button)

func select_vehicle(index: int) -> void:
    selected_car = index

    for child in car_display.get_children():
        car_display.remove_child(child)
        child.queue_free()

    var vehicle := create_vehicle(
        vehicle_colors[index],
        index
    )

    car_display.add_child(vehicle)
    car_title.text = vehicle_names[index]
    info_label.text = "Vehicle selected successfully"

func next_vehicle() -> void:
    var next_index := (
        selected_car + 1
    ) % vehicle_names.size()

    select_vehicle(next_index)

func previous_vehicle() -> void:
    var previous_index := (
        selected_car - 1 + vehicle_names.size()
    ) % vehicle_names.size()

    select_vehicle(previous_index)

func create_vehicle(
    body_color: Color,
    vehicle_type: int
) -> Node3D:
    var vehicle := Node3D.new()

    var body_size := Vector3(2.1, 0.8, 4.2)

    if vehicle_type == 1:
        body_size = Vector3(2.0, 0.65, 4.0)
    elif vehicle_type == 2:
        body_size = Vector3(2.2, 1.0, 4.3)

    add_box(
        vehicle,
        body_size,
        Vector3(0, 0.8, 0),
        body_color
    )

    add_box(
        vehicle,
        Vector3(1.7, 0.85, 1.9),
        Vector3(0, 1.55, -0.25),
        Color(0.18, 0.42, 0.62)
    )

    for x in [-1.0, 1.0]:
        for z in [-1.35, 1.35]:
            var wheel := MeshInstance3D.new()
            var wheel_mesh := CylinderMesh.new()

            wheel_mesh.top_radius = 0.38
            wheel_mesh.bottom_radius = 0.38
            wheel_mesh.height = 0.25

            wheel.mesh = wheel_mesh
            wheel.rotation_degrees.z = 90
            wheel.position = Vector3(x, 0.4, z)
            wheel.material_override = create_material(
                Color(0.025, 0.025, 0.03)
            )

            vehicle.add_child(wheel)

    return vehicle

func add_box(
    parent: Node3D,
    size: Vector3,
    position: Vector3,
    color: Color
) -> void:
    var object := MeshInstance3D.new()
    var mesh := BoxMesh.new()

    mesh.size = size
    object.mesh = mesh
    object.position = position
    object.material_override = create_material(color)

    parent.add_child(object)

func create_material(color: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()

    material.albedo_color = color
    material.roughness = 0.65

    return material

func start_game() -> void:
    info_label.text = "Driving mode will be added in the driving stage."

func open_garage() -> void:
    info_label.text = "Welcome to the 3D vehicle garage."

func open_settings() -> void:
    info_label.text = "Graphics and control settings are coming."
