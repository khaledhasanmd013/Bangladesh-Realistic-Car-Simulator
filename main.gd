
var driving_car: CarController
var driving_controls: MobileControls
var driving_layer: CanvasLayer
var main_menu_layer: CanvasLayer
var test_ground: StaticBody3D

extends Node3D

var garage: VehicleGarage
var shop: VehicleShop
var info_label: Label

func _ready() -> void:
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
    env.ambient_light_color = Color(0.75, 0.78, 0.85)
    env.ambient_light_energy = 0.8

    world.environment = env
    add_child(world)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-45, -30, 0)
    sun.light_energy = 1.3
    add_child(sun)

    var camera := Camera3D.new()
    camera.position = Vector3(0, 4.5, 10)
    camera.look_at(Vector3(0, 1, 0))
    camera.current = true
    add_child(camera)

func create_garage_system() -> void:
    garage = VehicleGarage.new()
    add_child(garage)

    garage.display_vehicle(
        VehicleData.get_vehicle(0)
    )

func create_shop_system() -> void:
    shop = VehicleShop.new()
    shop.set_anchors_and_offsets_preset(
        Control.PRESET_FULL_RECT
    )

    add_child(shop)
    shop.vehicle_selected.connect(_on_vehicle_selected)
    shop.hide()

func create_main_menu() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)

    var title := Label.new()
    title.text = "BANGLADESH REALISTIC CAR SIMULATOR"
    title.position = Vector2(20, 15)
    title.add_theme_font_size_override("font_size", 24)
    title.add_theme_color_override(
        "font_color", Color.WHITE
    )
    layer.add_child(title)

    var menu := VBoxContainer.new()
    menu.position = Vector2(25, 100)
    menu.add_theme_constant_override("separation", 10)
    layer.add_child(menu)

    add_menu_button(menu, "PLAY", start_game)
    add_menu_button(menu, "GARAGE", open_garage)
    add_menu_button(menu, "VEHICLE SHOP", open_shop)

    info_label = Label.new()
    info_label.position = Vector2(25, 470)
    info_label.add_theme_font_size_override("font_size", 18)
    info_label.add_theme_color_override(
        "font_color", Color.WHITE
    )
    info_label.text = "Welcome to Bangladesh!"
    layer.add_child(info_label)

func add_menu_button(
    parent: VBoxContainer,
    button_text: String,
    action: Callable
) -> void:
    var button := Button.new()
    button.text = button_text
    button.custom_minimum_size = Vector2(190, 48)
    button.pressed.connect(action)
    parent.add_child(button)

func open_garage() -> void:
    shop.hide()
    info_label.text = "Welcome to the vehicle garage."

func open_shop() -> void:
    shop.show()
    info_label.text = "Choose your vehicle."

func start_game() -> void:
    info_label.text = "Driving system is under development."

func _on_vehicle_selected(
    index: int,
    vehicle: Dictionary
) -> void:
    garage.display_vehicle(vehicle)
    shop.hide()
    info_label.text = "Selected: " + vehicle["name"]
