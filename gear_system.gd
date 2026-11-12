
extends RefCounted
class_name GearSystem

enum Mode {
    AUTOMATIC,
    MANUAL
}

enum AutomaticGear {
    PARK,
    REVERSE,
    NEUTRAL,
    DRIVE
}

var mode: Mode = Mode.AUTOMATIC
var automatic_gear: AutomaticGear = AutomaticGear.DRIVE
var manual_gear: int = 1

func toggle_mode() -> void:
    if mode == Mode.AUTOMATIC:
        mode = Mode.MANUAL
        manual_gear = 1
    else:
        mode = Mode.AUTOMATIC
        automatic_gear = AutomaticGear.DRIVE

func shift_automatic() -> void:
    if mode != Mode.AUTOMATIC:
        return

    automatic_gear = (
        (automatic_gear + 1) % 4
    ) as AutomaticGear

func shift_manual_up() -> void:
    if mode == Mode.MANUAL:
        manual_gear = mini(manual_gear + 1, 6)

func shift_manual_down() -> void:
    if mode == Mode.MANUAL:
        manual_gear = maxi(manual_gear - 1, 1)

func can_move() -> bool:
    if mode == Mode.MANUAL:
        return true

    return automatic_gear != AutomaticGear.PARK \
        and automatic_gear != AutomaticGear.NEUTRAL

func get_direction() -> float:
    if mode == Mode.MANUAL:
        return 1.0

    if automatic_gear == AutomaticGear.REVERSE:
        return -1.0

    if automatic_gear == AutomaticGear.DRIVE:
        return 1.0

    return 0.0

func get_gear_name() -> String:
    if mode == Mode.MANUAL:
        return "M" + str(manual_gear)

    match automatic_gear:
        AutomaticGear.PARK:
            return "P"
        AutomaticGear.REVERSE:
            return "R"
        AutomaticGear.NEUTRAL:
            return "N"
        AutomaticGear.DRIVE:
            return "D"

    return "N"

func get_mode_name() -> String:
    if mode == Mode.AUTOMATIC:
        return "AUTOMATIC"

    return "MANUAL"
