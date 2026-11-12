
extends Control
class_name MobileControls

signal throttle_changed(value: bool)
signal brake_changed(value: bool)
signal steering_changed(value: float)
signal camera_pressed
signal gear_mode_pressed
signal gear_up_pressed
signal gear_down_pressed

var speed_display: Label
var gear_display: Label

func _ready() -> void:
    set_anchors_and_offsets_preset(
        Control.PRESET_FULL_RECT
    )

    create_hud()
    create_controls()

func create_hud() -> void:
    speed_display = Label.new()
    speed_display.position = Vector2(20, 18)
    speed_display.add_theme_font_size_override(
        "font_size", 24
    )
    speed_display.add_theme_color_override(
        "font_color", Color.WHITE
    )
    add_child(speed_display)

    gear_display = Label.new()
    gear_display.position = Vector2(20, 55)
    gear_display.add_theme_font_size_override(
        "font_size", 20
    )
    gear_display.add_theme_color_override(
        "font_color", Color.WHITE
    )
    add_child(gear_display)

    update_hud(0, "D")

func create_controls() -> void:
    add_hold_button(
        "LEFT",
        0.0,
        Vector2(25, -105),
        Vector2(100, 75),
        func(value): steering_changed.emit(-1.0 if value else 0.0)
    )

    add_hold_button(
        "RIGHT",
        0.0,
        Vector2(140, -105),
        Vector2(100, 75),
        func(value): steering_changed.emit(1.0 if value else 0.0)
    )

    add_hold_button(
        "BRAKE",
        1.0,
        Vector2(-245, -105),
        Vector2(105, 75),
        func(value): brake_changed.emit(value)
    )

    add_hold_button(
        "GAS",
        1.0,
        Vector2(-125, -105),
        Vector2(105, 75),
        func(value): throttle_changed.emit(value)
    )

    add_action_button(
        "CAMERA",
        1.0,
        Vector2(-125, -195),
        Vector2(105, 48),
        func(): camera_pressed.emit()
    )

    add_action_button(
        "MODE",
        0.0,
        Vector2(25, -195),
        Vector2(100, 48),
        func(): gear_mode_pressed.emit()
    )

    add_action_button(
        "GEAR +",
        0.0,
        Vector2(140, -195),
        Vector2(100, 48),
        func(): gear_up_pressed.emit()
    )

    add_action_button(
        "GEAR -",
        0.0,
        Vector2(25, -250),
        Vector2(100, 48),
        func(): gear_down_pressed.emit()
    )

func add_hold_button(
    caption: String,
    horizontal_anchor: float,
    button_position: Vector2,
    button_size: Vector2,
    callback: Callable
) -> void:
    var button := Button.new()

    button.text = caption
    button.anchor_left = horizontal_anchor
    button.anchor_right = horizontal_anchor
    button.anchor_top = 1.0
    button.anchor_bottom = 1.0
    button.position = button_position
    button.size = button_size

    button.add_theme_font_size_override(
        "font_size", 19
    )

    button.button_down.connect(
        func(): callback.call(true)
    )

    button.button_up.connect(
        func(): callback.call(false)
    )

    add_child(button)

func add_action_button(
    caption: String,
    horizontal_anchor: float,
    button_position: Vector2,
    button_size: Vector2,
    callback: Callable
) -> void:
    var button := Button.new()

    button.text = caption
    button.anchor_left = horizontal_anchor
    button.anchor_right = horizontal_anchor
    button.anchor_top = 1.0
    button.anchor_bottom = 1.0
    button.position = button_position
    button.size = button_size

    button.add_theme_font_size_override(
        "font_size", 16
    )

    button.pressed.connect(callback)
    add_child(button)

func update_hud(speed: int, gear: String) -> void:
    if is_instance_valid(speed_display):
        speed_display.text = "SPEED: %d km/h" % speed

    if is_instance_valid(gear_display):
        gear_display.text = "GEAR: " + gear
