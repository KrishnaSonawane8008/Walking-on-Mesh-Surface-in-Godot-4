extends Node3D


@onready var Icosphere=$Icosphere
@onready var Player=$PlayerContainer
@onready var PlayerBasisRef=$PlayerBasisRefContainer
@onready var Player_Camera=$PlayerContainer/Palyer/Camera3D
@onready var Movable_Char=$"Movable Char"
var DebugCube=preload("res://DebugCube.tscn")

@onready var MultiplayerMap=$MultiplayerMap
var WalkingAPI=WalkOnSortedSurface.new("res://MultiplayerMap_MeshSortingData.cfg")
var mdt = MeshDataTool.new()
var HF=HelperFunctions.new(self)

var MainScale
var current_face=1208

func _ready():
	MainScale=MultiplayerMap.scale
	Movable_Char.Camera.current=true
	mdt.create_from_surface(MultiplayerMap.mesh, 0)
	
	#var MS=MeshSorter.new()
	#MS.SortMesh(MultiplayerMap.mesh, "res://MultiplayerMap_MeshSortingData.cfg")
	
	WalkingAPI.Put_Player_on_Centroid_of_Face( 1208, MainScale, Player, mdt )
	WalkingAPI.Put_Player_on_Centroid_of_Face( 1208, MainScale, PlayerBasisRef, mdt )


func _process(delta):
	if Input.is_action_pressed("Arrow_UP"):
		WalkingAPI.Add_input("Front")
	if Input.is_action_pressed("Arrow_DOWN"):
		WalkingAPI.Add_input("Back")
	if Input.is_action_pressed("Arrow_LEFT"):
		WalkingAPI.Add_input("Left")
	if Input.is_action_pressed("Arrow_RIGHT"):
		WalkingAPI.Add_input("Right")
	var Final_Dir=WalkingAPI.Get_Final_Direction()
	
	if(Final_Dir!="None"):
		var intersection_pt=WalkingAPI.get_next_move(PlayerBasisRef, Final_Dir, current_face, 0.3, MainScale, mdt)
		if(intersection_pt!=null):
				HF.DeSpawn_DebugCube()
				

				current_face=intersection_pt["Finalpt"][-1]
				#HF.Map_MeshFace(WalkingAPI.Face_Dict[current_face][0][0], mdt, MainScale, DebugCube)
				#HF.Map_MeshFace(WalkingAPI.Face_Dict[current_face][1][0], mdt, MainScale, DebugCube)
				#HF.Map_MeshFace(WalkingAPI.Face_Dict[current_face][2][0], mdt, MainScale, DebugCube)
				
				#HF.Display_PlayerDirectionPlane(Final_Dir, PlayerBasisRef, MainScale, DebugCube)
				var NextMove=WalkingAPI.Get_next_Face_Pos_And_Basis( current_face, Final_Dir, intersection_pt, PlayerBasisRef, mdt )
				Player.global_position=NextMove["NextPos"]
				PlayerBasisRef.global_position=NextMove["NextPos"]
				PlayerBasisRef.transform.basis=NextMove["NextBasis"]
				
				for edges in intersection_pt["PointArr"]:
					HF.Spawn_DebugCube_Line(edges[0], edges[1], DebugCube)
				for faces in intersection_pt["Finalpt"]:
					HF.Map_MeshFace(faces, mdt, MainScale, DebugCube)
					
		else:
			print("======================================================================")
			print("Null intersects")
			print("Intersects: ", intersection_pt)
			print("======================================================================")
	
	var LerpedBasis=lerp( Player.transform.basis.orthonormalized(), PlayerBasisRef.transform.basis.orthonormalized(), 0.05 )
	LerpedBasis.x*=Player.scale.x
	LerpedBasis.y*=Player.scale.y
	LerpedBasis.z*=Player.scale.z
	Player.transform.basis=LerpedBasis
	if Input.is_key_pressed(KEY_R):
		PlayerBasisRef.rotate_object_local(Vector3.UP, deg_to_rad(1))
#=======================================================================================================================================

func _unhandled_input(event):
	if(Player_Camera.current):
		if Input.is_mouse_button_pressed( MOUSE_BUTTON_RIGHT):
			if event is InputEventMouseMotion:
				Player_Camera.rotate_object_local(Vector3.RIGHT, -event.relative.y*0.00511111)
				Player.rotate_object_local(Vector3.UP, -event.relative.x*0.00511111)
				PlayerBasisRef.rotate_object_local(Vector3.UP, -event.relative.x*0.00511111)
#=======================================================================================================================================
	
	
	if Input.is_key_pressed(KEY_CTRL):
		if Input.is_key_pressed(KEY_SHIFT):
			if Input.is_key_pressed(KEY_C):
				Movable_Char.Camera.current=true
	if Input.is_key_pressed(KEY_CTRL):
		if Input.is_key_pressed(KEY_SHIFT):
			if Input.is_key_pressed(KEY_Z):
				Movable_Char.Camera.current=false

