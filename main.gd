extends Node3D

var garage: VehicleGarage
var shop: VehicleShop
var info_label: Label

var driving_car: CarController
var driving_controls: MobileControls
var driving_layer: CanvasLayer
var main_menu_layer: CanvasLayer

var road_manager: RoadManager
var traffic_vehicles: Array[Node3D] = []
var traffic_speeds: Array[float] = []

var game_started := false
var player_coins := 10000
var player_diamonds := 100
var player_level := 1
var player_xp := 0

const SAVE_PATH := "user://player_progress.save"


func _ready() -> void:
    load_progress()
    create_environment()
    create_garage_system()
    create_shop_system()
    create_main_menu()


func create_environment() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()

    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.12, 0.16, 0.23)
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.8, 0.8, 0.85)
    env.ambient_light_energy = 0.8

    world.environment = env
    add_child(world)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-45, -30, 0)
    sun.light_energy = 1.2
    add_child(sun)

    var camera := Camera3D.new()
    camera.position = Vector3(0, 5, 10)
    camera.look_at(Vector3(0, 1, 0))
    camera.current = true
    add_child(camera)


func create_garage_system() -> void:
    garage = VehicleGarage.new()
    add_child(garage)
    garage.display_vehicle(VehicleData.get_vehicle(0))


func create_shop_system() -> void:
    shop = VehicleShop.new()
    shop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shop)

    shop.vehicle_selected.connect(_on_vehicle_selected)
    shop.hide()


func create_main_menu() -> void:
    main_menu_layer = CanvasLayer.new()
    add_child(main_menu_layer)

    var title := Label.new()
    title.text = "BANGLADESH REALISTIC CAR SIMULATOR"
    title.position = Vector2(20, 15)
    title.add_theme_font_size_override("font_size", 24)
    title.add_theme_color_override("font_color", Color.WHITE)
    main_menu_layer.add_child(title)

    var menu := VBoxContainer.new()
    menu.position = Vector2(25, 100)
    menu.add_theme_constant_override("separation", 10)
    main_menu_layer.add_child(menu)

    add_menu_button(menu, "PLAY", start_game)
    add_menu_button(menu, "GARAGE", open_garage)
    add_menu_button(menu, "VEHICLE SHOP", open_shop)
    add_menu_button(menu, "SAVE PROGRESS", save_progress)
    add_menu_button(menu, "EXIT", exit_game)

    info_label = Label.new()
    info_label.position = Vector2(25, 470)
    info_label.add_theme_font_size_override("font_size", 18)
    info_label.add_theme_color_override("font_color", Color.WHITE)
    info_label.text = "Welcome to Bangladesh!"
    main_menu_layer.add_child(info_label)


func add_menu_button(parent: VBoxContainer, caption: String, action: Callable) -> void:
    var button := Button.new()
    button.text = caption
    button.custom_minimum_size = Vector2(190, 48)
    button.pressed.connect(action)
    parent.add_child(button)


func open_garage() -> void:
    shop.hide()
    garage.show()
    info_label.text = "Vehicle Garage"


func open_shop() -> void:
    garage.hide()
    shop.show()
    info_label.text = "Choose your vehicle"


func start_game() -> void:
    if game_started:
        return

    game_started = true
    shop.hide()
    garage.hide()
    main_menu_layer.hide()

    create_road_system()
    create_buildings()
    create_traffic()

    driving_car = CarController.new()
    driving_car.position = Vector3(0, 0.1, 5)
    add_child(driving_car)

    driving_layer = CanvasLayer.new()
    add_child(driving_layer)

    driving_controls = MobileControls.new()
    driving_layer.add_child(driving_controls)

    driving_controls.throttle_changed.connect(driving_car.set_throttle)
    driving_controls.brake_changed.connect(driving_car.set_brake)
    driving_controls.steering_changed.connect(driving_car.set_steering)
    driving_controls.camera_pressed.connect(driving_car.change_camera)
    driving_controls.gear_mode_pressed.connect(driving_car.toggle_gear_mode)
    driving_controls.gear_up_pressed.connect(driving_car.shift_gear_up)
    driving_controls.gear_down_pressed.connect(driving_car.shift_gear_down)


func create_road_system() -> void:
    road_manager = RoadManager.new()
    add_child(road_manager)


func create_buildings() -> void:
    for i in range(12):
        var z_position := -20.0 - float(i) * 22.0

        create_building(
            Vector3(-13, 0, z_position),
            Vector3(5, 7 + float(i % 3) * 2, 8),
            Color(0.72, 0.62, 0.48)
        )

        create_building(
            Vector3(13, 0, z_position - 8),
            Vector3(5, 5 + float(i % 2) * 2, 7),
            Color(0.65, 0.72, 0.78)
        )


func create_building(pos: Vector3, dimensions: Vector3, building_color: Color) -> void:
    var building := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = dimensions
    building.mesh = mesh
    building.position = pos + Vector3(0, dimensions.y / 2.0, 0)

    var material := StandardMaterial3D.new()
    material.albedo_color = building_color
    material.roughness = 0.9
    building.material_override = material

    add_child(building)

    # সামনের দিকে একটি দরজার মতো অংশ
    var door := MeshInstance3D.new()
    var door_mesh := BoxMesh.new()
    door_mesh.size = Vector3(1.0, 2.0, 0.12)
    door.mesh = door_mesh
    door.position = building.position + Vector3(0, -dimensions.y / 2.0 + 1.0, dimensions.z / 2.0 + 0.08)

    var door_material := StandardMaterial3D.new()
    door_material.albedo_color = Color(0.25, 0.14, 0.08)
    door.material_override = door_material
    add_child(door)


func create_traffic() -> void:
    var types := [
        {"name": "BUS", "color": Color(0.9, 0.65, 0.08), "speed": 10.0},
        {"name": "TRUCK", "color": Color(0.25, 0.35, 0.55), "speed": 8.0},
        {"name": "CAR", "color": Color(0.8, 0.12, 0.12), "speed": 14.0},
        {"name": "CNG", "color": Color(0.1, 0.65, 0.25), "speed": 7.0},
        {"name": "VAN", "color": Color(0.75, 0.75, 0.72), "speed": 9.0}
    ]

    for i in range(10):
        var traffic_type: Dictionary = types[i % types.size()]
        var vehicle := create_traffic_vehicle(
            traffic_type["name"],
            traffic_type["color"]
        )

        vehicle.position = Vector3(
            -3.5 if i % 2 == 0 else 3.5,
            0.6,
            -25.0 - float(i) * 24.0
        )

        traffic_vehicles.append(vehicle)
        traffic_speeds.append(float(traffic_type["speed"]))
        add_child(vehicle)


func create_traffic_vehicle(vehicle_name: String, vehicle_color: Color) -> Node3D:
    var vehicle := Node3D.new()

    var body := MeshInstance3D.new()
    var body_mesh := BoxMesh.new()

    if vehicle_name == "BUS":
        body_mesh.size = Vector3(2.5, 2.8, 7.0)
    elif vehicle_name == "TRUCK":
        body_mesh.size = Vector3(2.5, 2.5, 6.0)
    elif vehicle_name == "CNG":
        body_mesh.size = Vector3(1.5, 1.6, 2.5)
    else:
        body_mesh.size = Vector3(2.0, 1.5, 4.0)

    body.mesh = body_mesh
    body.position.y = 0.8

    var material := StandardMaterial3D.new()
    material.albedo_color = vehicle_color
    body.material_override = material

    vehicle.add_child(body)

    return vehicle


func _process(delta: float) -> void:
    if game_started:
        update_traffic(delta)
        update_driving_hud()


func update_traffic(delta: float) -> void:
    for i in range(traffic_vehicles.size()):
        var vehicle := traffic_vehicles[i]

        if not is_instance_valid(vehicle):
            continue

        vehicle.position.z -= traffic_speeds[i] * delta

        if vehicle.position.z < -280.0:
            vehicle.position.z = 30.0 + float(i) * 15.0


func update_driving_hud() -> void:
    if is_instance_valid(driving_car) and is_instance_valid(driving_controls):
        driving_controls.update_hud(
            driving_car.get_speed_kmh(),
            driving_car.get_current_gear()
        )


func _on_vehicle_selected(index: int, vehicle: Dictionary) -> void:
    garage.display_vehicle(vehicle)
    garage.show()
    shop.hide()
    info_label.text = "Selected: " + str(vehicle.get("name", "Vehicle"))


func save_progress() -> void:
    var data := {
        "coins": player_coins,
        "diamonds": player_diamonds,
        "level": player_level,
        "xp": player_xp
    }

    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)

    if file == null:
        info_label.text = "Could not save progress"
        return

    file.store_var(data)
    file.close()
    info_label.text = "Progress saved"


func load_progress() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        return

    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

    if file == null:
        return

    var data: Variant = file.get_var()
    file.close()

    if data is Dictionary:
        player_coins = int(data.get("coins", 10000))
        player_diamonds = int(data.get("diamonds", 100))
        player_level = int(data.get("level", 1))
        player_xp = int(data.get("xp", 0))


func exit_game() -> void:
    get_tree().quit()

