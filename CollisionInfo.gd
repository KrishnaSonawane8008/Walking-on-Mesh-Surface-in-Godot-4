@tool
extends RayCast3D


@onready var RayCastMesh=$RayCastIdentifier
@onready var CollptMesh=$CollisionPt
var RS=RenderingServer
var World=World3D.new()
var mdt=MeshDataTool.new()
@onready var MyParent=$".."
var HF
var DebugCube=preload("res://DebugCube.tscn")
@onready var TheMesh=$"../MultiplayerMap"


# Called when the node enters the scene tree for the first time.
func _ready():
	RayCastMesh.scale.x=0.1
	RayCastMesh.scale.z=0.1
	CollptMesh.scale.x=0.2
	CollptMesh.scale.y=0.2
	CollptMesh.scale.z=0.2
	HF=HelperFunctions.new(MyParent)
	mdt.create_from_surface( TheMesh.mesh, 0 )


func _process(delta):
	var RayCast_Length=(global_position.distance_to(global_position+transform.basis.y.normalized()*target_position.y))
	RayCastMesh.scale.y=RayCast_Length
	RayCastMesh.global_position=global_position+(transform.basis.y.normalized()*(target_position.y/2))
	
func _physics_process(delta):
	
	if(get_collision_face_index()!=-1 && get_collider().get_parent()==TheMesh):
		HF.Map_MeshFace(get_collision_face_index(), mdt, TheMesh.scale, DebugCube)
		print(get_collision_face_index())
	CollptMesh.global_position=global_position+(transform.basis.y.normalized()*target_position.y)
	if(get_collision_point()):
		CollptMesh.global_position=get_collision_point()

