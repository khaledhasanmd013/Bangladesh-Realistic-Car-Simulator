
extends Node3D
class_name RoadManager

enum RoadType {
    CITY,
    VILLAGE,
    HIGHWAY
}

var current_road_type: RoadType = RoadType.VILLAGE

func _ready() -> void:
    create_road()

func create_road() -> void:
    create_ground()
    create_asphalt()
    create_lane_markings()
    create_roadside_objects()

func create_ground() -> void:
    var ground := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = Vector3(100, 0.2, 300)
    ground.mesh = mesh
    ground.position = Vector3(0, -0.3, -100)

    var material := StandardMaterial3D.new()
    material.albedo_color = Color(0.25, 0.48, 0.2)
    ground.material_override = material
    add_child(ground)

func create_asphalt() -> void:
    var road := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = Vector3(12, 0.15, 300)
    road.mesh = mesh
    road.position = Vector3(0, -0.1, -100)

    var material := StandardMaterial3D.new()
    material.albedo_color = Color(0.12, 0.12, 0.13)
    road.material_override = material
    add_child(road)

func create_lane_markings() -> void:
    for i in range(30):
        var line := MeshInstance3D.new()
        var mesh := BoxMesh.new()
        mesh.size = Vector3(0.15, 0.03, 3.0)
        line.mesh = mesh
        line.position = Vector3(0, 0.0, -i * 10.0)

        var material := StandardMaterial3D.new()
        material.albedo_color = Color.WHITE
        line.material_override = material
        add_child(line)

func create_roadside_objects() -> void:
    for i in range(12):
        create_tree(-9, -i * 22.0)
        create_tree(9, -i * 22.0)

func create_tree(x: float, z: float) -> void:
    var trunk := MeshInstance3D.new()
    var trunk_mesh := CylinderMesh.new()
    trunk_mesh.top_radius = 0.2
    trunk_mesh.bottom_radius = 0.3
    trunk_mesh.height = 2.5
    trunk.mesh = trunk_mesh
    trunk.position = Vector3(x, 1.25, z)

    var trunk_material := StandardMaterial3D.new()
    trunk_material.albedo_color = Color(0.3, 0.16, 0.07)
    trunk.material_override = trunk_material
    add_child(trunk)

    var leaves := MeshInstance3D.new()
    var leaves_mesh := SphereMesh.new()
    leaves_mesh.radius = 1.5
    leaves_mesh.height = 3.0
    leaves.mesh = leaves_mesh
    leaves.position = Vector3(x, 3.0, z)

    var leaves_material := StandardMaterial3D.new()
    leaves_material.albedo_color = Color(0.08, 0.38, 0.12)
    leaves.material_override = leaves_material
    add_child(leaves)
