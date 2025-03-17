extends Node

class_name MeshSorter

var Face_dict={}
var Lone_edges=[]
#{ CurrentFace:[ [Face_OppTo_Edge0ofCurrentFace, EdgeofOppFace_OppTo_Edge0ofCurrentFace], 
#                [Face_OppTo_Edge1ofCurrentFace, EdgeofOppFace_OppTo_Edge1ofCurrentFace], 
#                [Face_OppTo_Edge2ofCurrentFace, EdgeofOppFace_OppTo_Edge2ofCurrentFace] ], .......................  }

func SortMesh(mesh: ArrayMesh, CfgFile_Location: String):
	var mdt=MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	
	for i in range(mdt.get_face_count()):
		Face_dict[i]=[]
		for i_edge in range(3):
			var Edge=mdt.get_face_edge(i, i_edge)
			var Edge_vert1=mdt.get_vertex(mdt.get_edge_vertex(Edge, 0))
			var Edge_vert2=mdt.get_vertex(mdt.get_edge_vertex(Edge, 1))
			for j in range(mdt.get_face_count()):
				if(j!=i):
					for l in range(3):
						var J_Face_Edge=mdt.get_face_edge(j, l)
						var J_Face_Edge_vert1=mdt.get_vertex(mdt.get_edge_vertex(J_Face_Edge, 0))
						var J_Face_Edge_vert2=mdt.get_vertex(mdt.get_edge_vertex(J_Face_Edge, 1))
						if(J_Face_Edge_vert1==Edge_vert1 && J_Face_Edge_vert2==Edge_vert2):
							Face_dict[i].append([j, l])
							break
						elif(J_Face_Edge_vert1==Edge_vert2 && J_Face_Edge_vert2==Edge_vert1):
							Face_dict[i].append([j, l])
							break
							
				if(Face_dict[i].size()>=3):
					break
	for i in range(mdt.get_edge_count()):
		if(mdt.get_edge_faces(i).size()<1):
			Lone_edges.append(i)

	print("SORTING DONE")
	var SizeExceptions=[]
	var OppFaceExceptions=[]
	for i in Face_dict:
		if(Face_dict[i].size()!=3):
			SizeExceptions.append(Face_dict[i])
			for eles in Face_dict[i]:
				if(eles.size()!=2):
					OppFaceExceptions.append(Face_dict[i])
	var cfg=ConfigFile.new()
	var Err=cfg.load(CfgFile_Location)
	if Err!=OK:
		print("ERROR WHILE ASSIGNING TO CFG")
	else:
		cfg.set_value("walking_surface", "Face_Dict", Face_dict)
		cfg.save(CfgFile_Location)
		
	Print_Exceptions(SizeExceptions, OppFaceExceptions)
	

func Print_Exceptions(SizeExceptions, OppFaceExceptions):
	if(SizeExceptions.size()>0):
		print("===========================SizeExceptions============================")
		for i in SizeExceptions:
			print(i)
		print("=====================================================================")
	if(OppFaceExceptions.size()>0):
		print("===========================OppFaceExceptions============================")
		for i in OppFaceExceptions:
			print(i)
		print("=====================================================================")
	if(Lone_edges.size()>0):
		print("===========================LoneEdgeExceptions============================")
		print("Lone Edges: ", Lone_edges)
		print("=====================================================================")
	else:
		print("=====================================================================")
		print("NO EXCEPTIONS")
	
