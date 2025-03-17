extends Node

class_name HelperFunctions


var DebugCube_inst_list=[]
var Parent

func _init(parent):
	Parent=parent
	
func Spawn_DebugCube(pos, CubePreload):
	var TheCube=CubePreload.instantiate()
	Parent.add_child(TheCube)
	DebugCube_inst_list.append(TheCube)
	TheCube.global_position=pos

func DeSpawn_DebugCube():
	for i in DebugCube_inst_list:
		i.queue_free()
	DebugCube_inst_list.clear()

func get_CentroidOfFace(Face, MDT, Scale):
	var AdditionOfVertices=( (MDT.get_vertex(MDT.get_face_vertex(Face, 0)))*Scale)+( (MDT.get_vertex(MDT.get_face_vertex(Face, 1)))*Scale)+( (MDT.get_vertex(MDT.get_face_vertex(Face, 2)))*Scale)
	return AdditionOfVertices/3
	
func get_CentroidOfTriangle(Triangle_Points):
	var AdditionOfVertices=Triangle_Points[0]+Triangle_Points[1]+Triangle_Points[2]
	return AdditionOfVertices/3

func Put_CubeAtCentroid(Face, MDT, Scale, CubePreload):
	if(Face<MDT.get_face_count()):
		var centroid=get_CentroidOfFace(Face, MDT, Scale)
		Spawn_DebugCube(centroid, CubePreload)

func get_Normal_Aligned_Basis(Normal, Instance):
	var rot_axis=((Instance.transform.basis.y.normalized()).cross(Normal.normalized())).normalized()
	if(Vector3(abs(rot_axis.x), abs(rot_axis.y), abs(rot_axis.z))!=Vector3(0,0,0) && !is_VecEqual_Approx(Instance.transform.basis.y, Normal, 5)):
		#print("Rotation Axis Addition: ",rot_axis.normalized().x+rot_axis.normalized().y+rot_axis.normalized().z)
		var angle= (Instance.transform.basis.y.normalized()).angle_to(Normal.normalized())
		var quat= Quaternion( rot_axis.normalized(), angle )
		var quat_mult=quat*Instance.transform.basis.get_rotation_quaternion()
		var result=Basis(quat_mult)

		result.x *= Instance.scale.x
		result.y *= Instance.scale.y
		result.z *= Instance.scale.z
		
		return result
	else:
		return Instance.transform.basis
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
func is_VecEqual_Approx(vec1, vec2, digits):
	if( round_to_dec(vec1.x, digits)==round_to_dec(vec2.x, digits) && round_to_dec(vec1.y, digits)==round_to_dec(vec2.y, digits) && round_to_dec(vec1.z, digits)==round_to_dec(vec2.z, digits) ):
		return true
	else:
		return false

func Spawn_DebugCube_Line(start, end, CubePreload):
	var TheCube=CubePreload.instantiate()
	Parent.add_child(TheCube)
	DebugCube_inst_list.append(TheCube)
	
	var dir=(end-start).normalized()
	var dist=start.distance_to( end )
	var halfway_point=start+(dir*(dist/2))
	TheCube.global_position=halfway_point
	
	TheCube.transform.basis=get_Normal_Aligned_Basis(dir, TheCube)
	TheCube.scale.x=TheCube.scale.x*0.5
	TheCube.scale.y=dist
	TheCube.scale.z=TheCube.scale.z*0.5

func Map_MeshFace(Face, MDT, Scale, CubePreload):
	Spawn_DebugCube( (MDT.get_vertex(MDT.get_face_vertex(Face, 0)))*Scale, CubePreload )
	Spawn_DebugCube( (MDT.get_vertex(MDT.get_face_vertex(Face, 1)))*Scale, CubePreload )
	Spawn_DebugCube( (MDT.get_vertex(MDT.get_face_vertex(Face, 2)))*Scale, CubePreload )
	
	Spawn_DebugCube_Line( (MDT.get_vertex(MDT.get_face_vertex(Face, 0)))*Scale, (MDT.get_vertex(MDT.get_face_vertex(Face, 1)))*Scale, CubePreload )
	Spawn_DebugCube_Line( (MDT.get_vertex(MDT.get_face_vertex(Face, 1)))*Scale, (MDT.get_vertex(MDT.get_face_vertex(Face, 2)))*Scale, CubePreload )
	Spawn_DebugCube_Line( (MDT.get_vertex(MDT.get_face_vertex(Face, 2)))*Scale, (MDT.get_vertex(MDT.get_face_vertex(Face, 0)))*Scale, CubePreload )

func Map_Traingle(pt1, pt2, pt3, CubePreload):
	Spawn_DebugCube_Line(pt1,pt2, CubePreload )
	Spawn_DebugCube_Line(pt2,pt3, CubePreload )
	Spawn_DebugCube_Line(pt1,pt3, CubePreload )

func Map_MeshFace_Edge(Face, edge, Scale, MDT: MeshDataTool, CubePreload):
	Spawn_DebugCube_Line( (MDT.get_vertex(MDT.get_edge_vertex(MDT.get_face_edge( Face, edge ), 0)))*Scale,
						  (MDT.get_vertex(MDT.get_edge_vertex(MDT.get_face_edge( Face, edge ), 1)))*Scale,
						  CubePreload )


func get_Face_Plane(Face, Scale, MDT: MeshDataTool):
	return Plane( (MDT.get_vertex(MDT.get_face_vertex(Face, 0)))*Scale, 
				  (MDT.get_vertex(MDT.get_face_vertex(Face, 1)))*Scale,
				  (MDT.get_vertex(MDT.get_face_vertex(Face, 2)))*Scale )

func Get_PlayerDirectionPlane_W_PlayerDirection(Direction, Player_Node):
	if(Direction=="Front"):
		return {"Plane": Plane(Player_Node.transform.origin, 
					 		   Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 		   Player_Node.transform.origin - Player_Node.transform.basis.z.normalized()),
				"Direction": -Player_Node.transform.basis.z.normalized() 
				}
					
	elif(Direction=="Right"):
		return {"Plane": Plane(Player_Node.transform.origin,
				 	 		   Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
				 	 		   Player_Node.transform.origin + Player_Node.transform.basis.y.cross(Player_Node.transform.basis.z).normalized()),
				"Direction": Player_Node.transform.basis.y.cross(Player_Node.transform.basis.z).normalized() 
				}
					
	elif(Direction=="Left"):
		return {"Plane": Plane(Player_Node.transform.origin,
				 	 		   Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
				 	 		   Player_Node.transform.origin - Player_Node.transform.basis.y.cross(Player_Node.transform.basis.z).normalized()),
				"Direction": -Player_Node.transform.basis.y.cross(Player_Node.transform.basis.z).normalized() 
				}
					
	elif(Direction=="Back"):
		return {"Plane": Plane(Player_Node.transform.origin,
				 	 		   Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
				 	 		   Player_Node.transform.origin + Player_Node.transform.basis.z.normalized()),
				"Direction": Player_Node.transform.basis.z.normalized() 
				}
					
	elif(Direction=="Front-Right"):
		return {"Plane": Plane(Player_Node.transform.origin,
				 	 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
				 	 Player_Node.transform.origin + (-Player_Node.basis.z+Player_Node.basis.x).normalized()),
				"Direction": (-Player_Node.basis.z+Player_Node.basis.x).normalized()
				}
					
	elif(Direction=="Front-Left"):
		return {"Plane": Plane(Player_Node.transform.origin,
				 	 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
				 	 Player_Node.transform.origin + (-Player_Node.basis.z-Player_Node.basis.x).normalized()),
				"Direction": (-Player_Node.basis.z-Player_Node.basis.x).normalized()
				}
					
	elif(Direction=="Back-Right"):
		return {"Plane": Plane(Player_Node.transform.origin,
				 	 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
				 	 Player_Node.transform.origin + (Player_Node.basis.z+Player_Node.basis.x).normalized()),
				"Direction": (Player_Node.basis.z+Player_Node.basis.x).normalized()
				}
					
	elif(Direction=="Back-Left"):
		return {"Plane": Plane(Player_Node.transform.origin,
				 	 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
				 	 Player_Node.transform.origin + (Player_Node.basis.z-Player_Node.basis.x).normalized()),
				"Direction": (Player_Node.basis.z-Player_Node.basis.x).normalized()
				}


func Display_PlayerDirectionPlane(Direction, Player_Node, Scale, CubePreload):
	if(Direction=="Front"):
		#front
		Map_Traingle(Player_Node.transform.origin,
					 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 Player_Node.transform.origin - Player_Node.transform.basis.z.normalized(),
					 CubePreload)
	elif(Direction=="Right"):
		#right
		Map_Traingle(Player_Node.transform.origin,
					 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 Player_Node.transform.origin + Player_Node.transform.basis.y.cross(Player_Node.transform.basis.z).normalized(),
					 CubePreload)
	elif(Direction=="Left"):
		#left
		Map_Traingle(Player_Node.transform.origin,
					 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 Player_Node.transform.origin - Player_Node.transform.basis.y.cross(Player_Node.transform.basis.z).normalized(),
					 CubePreload)
	elif(Direction=="Back"):
		#back
		Map_Traingle(Player_Node.transform.origin,
					 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 Player_Node.transform.origin + Player_Node.transform.basis.z.normalized(),
					 CubePreload)
	elif(Direction=="Front-Right"):
		#front-right
		Map_Traingle(Player_Node.transform.origin,
					 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 Player_Node.transform.origin + (-Player_Node.basis.z+Player_Node.basis.x).normalized(),
					 CubePreload)
	elif(Direction=="Front-Left"):
		#front-left
		Map_Traingle(Player_Node.transform.origin,
					 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 Player_Node.transform.origin + (-Player_Node.basis.z-Player_Node.basis.x).normalized(),
					 CubePreload)
	elif(Direction=="Back-Right"):
		#back-right
		Map_Traingle(Player_Node.transform.origin,
					 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 Player_Node.transform.origin + (Player_Node.basis.z+Player_Node.basis.x).normalized(),
					 CubePreload)
	elif(Direction=="Back-Left"):
		#back-left
		Map_Traingle(Player_Node.transform.origin,
					 Player_Node.transform.origin + Player_Node.transform.basis.y.normalized(), 
					 Player_Node.transform.origin + (Player_Node.basis.z-Player_Node.basis.x).normalized(),
					 CubePreload)

func Get_PlayerDirection(Direction, Player_Node):
	if(Direction=="Front"):
		return -Player_Node.transform.basis.z.normalized()
		
	elif(Direction=="Right"):
		return Player_Node.transform.basis.y.cross(Player_Node.transform.basis.z).normalized()
		
	elif(Direction=="Left"):
		return -Player_Node.transform.basis.y.cross(Player_Node.transform.basis.z).normalized()
		
	elif(Direction=="Back"):
		return Player_Node.transform.basis.z.normalized()
		
	elif(Direction=="Front-Right"):
		return (-Player_Node.basis.z+Player_Node.basis.x).normalized()
		
	elif(Direction=="Front-Left"):
		return Player_Node.transform.origin + (-Player_Node.basis.z-Player_Node.basis.x).normalized()
		
	elif(Direction=="Back-Right"):
		return Player_Node.transform.origin + (Player_Node.basis.z+Player_Node.basis.x).normalized()
		
	elif(Direction=="Back-Left"):
		return Player_Node.transform.origin + (Player_Node.basis.z-Player_Node.basis.x).normalized()
		





















