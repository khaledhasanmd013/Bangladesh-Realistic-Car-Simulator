
extends RefCounted
class_name VehicleData

const VEHICLES := [
    {
        "id": "microbus_01",
        "name": "Bangladesh Microbus",
        "type": "Microbus",
        "price": 0,
        "currency": "coins",
        "max_speed": 140,
        "acceleration": 12.0,
        "color": Color(0.08, 0.35, 0.85)
    },
    {
        "id": "sports_01",
        "name": "Sports Car",
        "type": "Sports",
        "price": 2500,
        "currency": "coins",
        "max_speed": 220,
        "acceleration": 22.0,
        "color": Color(0.85, 0.12, 0.08)
    },
    {
        "id": "suv_01",
        "name": "Family SUV",
        "type": "SUV",
        "price": 4000,
        "currency": "coins",
        "max_speed": 180,
        "acceleration": 15.0,
        "color": Color(0.12, 0.55, 0.25)
    },
    {
        "id": "microbus_02",
        "name": "Luxury Microbus",
        "type": "Microbus",
        "price": 6500,
        "currency": "diamonds",
        "max_speed": 170,
        "acceleration": 16.0,
        "color": Color(0.75, 0.72, 0.62)
    }
]

static func get_all() -> Array:
    return VEHICLES.duplicate(true)

static func get_vehicle(index: int) -> Dictionary:
    if index < 0 or index >= VEHICLES.size():
        return {}

    return VEHICLES[index].duplicate(true)

static func get_vehicle_count() -> int:
    return VEHICLES.size()

static func get_vehicle_by_id(vehicle_id: String) -> Dictionary:
    for vehicle in VEHICLES:
        if vehicle["id"] == vehicle_id:
            return vehicle.duplicate(true)

    return {}
