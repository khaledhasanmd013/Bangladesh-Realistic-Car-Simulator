
extends Control
class_name VehicleShop

signal vehicle_selected(index: int, vehicle: Dictionary)
signal balance_changed(coins: int, diamonds: int)

var coins: int = 10000
var diamonds: int = 100

var owned_vehicles: Array[String] = [
    "microbus_01"
]

var selected_index: int = 0

var vehicle_list: VBoxContainer
var details_label: Label
var balance_label: Label

func _ready() -> void:
    build_shop_interface()
    refresh_shop()

func build_shop_interface() -> void:
    var background := ColorRect.new()
    background.color = Color(0.06, 0.08, 0.12, 0.95)
    background.set_anchors_and_offsets_preset(
        Control.PRESET_FULL_RECT
    )
    add_child(background)

    var panel := VBoxContainer.new()
    panel.position = Vector2(25, 20)
    panel.size = Vector2(420, 490)
    panel.add_theme_constant_override("separation", 10)
    add_child(panel)

    var title := Label.new()
    title.text = "VEHICLE SHOP"
    title.add_theme_font_size_override("font_size", 28)
    panel.add_child(title)

    balance_label = Label.new()
    balance_label.add_theme_font_size_override("font_size", 18)
    panel.add_child(balance_label)

    details_label = Label.new()
    details_label.custom_minimum_size = Vector2(0, 75)
    details_label.add_theme_font_size_override("font_size", 17)
    panel.add_child(details_label)

    var scroll := ScrollContainer.new()
    scroll.custom_minimum_size = Vector2(390, 260)
    panel.add_child(scroll)

    vehicle_list = VBoxContainer.new()
    vehicle_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    vehicle_list.add_theme_constant_override("separation", 8)
    scroll.add_child(vehicle_list)

    var close_button := Button.new()
    close_button.text = "CLOSE SHOP"
    close_button.custom_minimum_size = Vector2(180, 45)
    close_button.pressed.connect(close_shop)
    panel.add_child(close_button)

func refresh_shop() -> void:
    if not is_instance_valid(vehicle_list):
        return

    for child in vehicle_list.get_children():
        child.queue_free()

    balance_label.text = (
        "Coins: %d     Diamonds: %d"
        % [coins, diamonds]
    )

    var vehicles := VehicleData.get_all()

    for i in range(vehicles.size()):
        var data: Dictionary = vehicles[i]

        var button := Button.new()
        button.custom_minimum_size = Vector2(360, 48)

        var is_owned: bool = owned_vehicles.has(data["id"])

        if is_owned:
            button.text = "%s  -  OWNED" % data["name"]
        else:
            button.text = "%s  -  %d %s" % [
                data["name"],
                data["price"],
                data["currency"]
            ]

        button.pressed.connect(
            func(): select_shop_vehicle(i)
        )

        vehicle_list.add_child(button)

func select_shop_vehicle(index: int) -> void:
    selected_index = index

    var data := VehicleData.get_vehicle(index)

    if data.is_empty():
        return

    var owned: bool = owned_vehicles.has(data["id"])

    details_label.text = (
        "Vehicle: %s\nType: %s\nMax speed: %d km/h\n%s"
        % [
            data["name"],
            data["type"],
            data["max_speed"],
            "Already owned" if owned else "Available to purchase"
        ]
    )

    if owned:
        vehicle_selected.emit(index, data)
        return

    purchase_vehicle(index)

func purchase_vehicle(index: int) -> void:
    var data := VehicleData.get_vehicle(index)

    if data.is_empty():
        return

    var vehicle_id: String = data["id"]
    var price: int = data["price"]
    var currency: String = data["currency"]

    if owned_vehicles.has(vehicle_id):
        vehicle_selected.emit(index, data)
        return

    if currency == "coins":
        if coins < price:
            details_label.text = "Not enough coins!"
            return

        coins -= price

    elif currency == "diamonds":
        if diamonds < price:
            details_label.text = "Not enough diamonds!"
            return

        diamonds -= price

    owned_vehicles.append(vehicle_id)

    balance_changed.emit(coins, diamonds)
    details_label.text = "Vehicle purchased successfully!"

    refresh_shop()
    vehicle_selected.emit(index, data)

func close_shop() -> void:
    hide()
