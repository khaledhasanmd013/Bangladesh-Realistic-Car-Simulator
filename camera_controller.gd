
extends Node3D
class_name VehicleCameraController

enum CameraMode {
    REAR,
    COCKPIT,
    HOOD
}

var current_mode: CameraMode = CameraMode.REAR
var camera: Camera3D

func _ready() -> void:
    camera = Camera3D.new()
    camera.fov = 72.0
    add_child(camera)
    set_camera_mode(CameraMode.REAR)

func next_camera() -> void:
    var next_mode := (
        (current_mode + 1) % 3
    ) as CameraMode

    set_camera_mode(next_mode)

func set_camera_mode(mode: CameraMode) -> void:
    current_mode = mode

    match current_mode:
        CameraMode.REAR:
            camera.position = Vector3(0, 4.5, 8.5)
            camera.rotation_degrees = Vector3(-18, 0, 0)
            camera.fov = 72.0

        CameraMode.COCKPIT:
            camera.position = Vector3(0, 1.65, -0.25)
            camera.rotation_degrees = Vector3(0, 0, 0)
            camera.fov = 85.0

        CameraMode.HOOD:
            camera.position = Vector3(0, 2.0, -2.2)
            camera.rotation_degrees = Vector3(-3, 0, 0)
            camera.fov = 78.0

    camera.current = true

func get_camera_name() -> String:
    match current_mode:
        CameraMode.REAR:
            return "REAR CAMERA"
        CameraMode.COCKPIT:
            return "COCKPIT CAMERA"
        CameraMode.HOOD:
            return "HOOD CAMERA"

    return "CAMERA"
