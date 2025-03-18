Using Godot v4.2.1 stable
<br>
The project aims to provide a method to let your player character(a 3D model) to walk on any 3D mesh with "clean geometry"(more on this later).
<br>
<h1>How to Set Up</h1>
First you will need a 3d mesh which is supposed to be walked on by a player character, then you will need the player character itself which will be another 3D model ehich should be standing upright, and any node which will be used as a reference to the player characters basis(this is intended to make lerping more smooth when the player walks on another mesh's surface).
<br>
<br>
The initial step for setting up the surface traversal will be a "scan" of the surface. The surface(the player will be walking on) or the 3D model of the walking ground needs to have "clean geometry", what that means is that each triangle on the model needs to have no less than 3 traingles around it, each adjacent to to its edges, bascially the model needs to be completely connected. To begin the scan you will need the MeshSorter class provded in the project, use the SortMesh() function of the class "scan" the walking surface and store the generated data in a CFG file(you will need this file later).
<br>
<br>
Code to "scan" the mesh(icosphere is the walking surface mesh):
<img src="/CodeSnippets/Initailizationcode.png">
<br>
If everything is correct, then this message will appear in the output window:
<img src="/CodeSnippets/OutputMessage.png">
<br>
Once the data of the mesh has been stored in a cfg, you need to put the player character on one of the faces of the mesh in the start(this can be done manually with MeshDataTool by guesssing the mesh face, or by using a raycast). Once you have the face index of the starting face, use the WalkOnSortedSurface class to place the player characters 3D model on that face, rest of the code is regarding player input and using the WalkOnSortedSurface class to move the player on the desired surface. The WalkOnSortedSurface class provides a framework to take in player input to decide the direction in which the player can move, once initialzed, the player can move in eight directions depending on input, namely front, right, left, back, front-right, front-left, back-right, & back-left. The code for movement can be called repeatedly in the _process() function in the main script:
<br>
<br>
Code needed to initialize the WalkOnSortedSurface class (the location provided is the location of the cfg file generated in the first step):
<img src="/CodeSnippets/Globals.png">
<br>
The MainScale variable ensures that if the walking surface is scaled then the player movement is correct, MovableChar, DebugCube and HelperFunctions class is just something i used for debugging, you don't need to put them in you code if you don't want to.
<br>
<br>
Code to put player on the starting face in the beginning:
<img src="/CodeSnippets/_ready.png">
<br>
Code to call in the process() function for player input and character movement on desired surface:
<img src="/CodeSnippets/_process.png" > 
<br>
In the above code, MultiplayerMap is the meshinstance3d node containing the desired walking surface mesh, PlayerBasisRef is the reference node to be used for making the player movement smooth via lerping, and 1208 is the index of the starting face in the 3D model(if you are confused about the mesh and face index stuff, read about the <a href="https://docs.godotengine.org/en/stable/classes/class_meshdatatool.html">MeshDataTool</a> class in the godot 4.2.1 documentation). 
<br>
<h1>Final Output</h1>
Once everything is setup and you didn't get any errors while "scaning" the mesh, then you should be able to see your player character move freely on the desired surface like this:
<br>
<br>
3rd person view:
<video src="https://github.com/user-attachments/assets/079ac130-108e-4083-a6f8-5d4f476ae97e"></video>
3rd person view with the same walking surface but the visibility of walking surface mesh turned off:
<video src="https://github.com/user-attachments/assets/404b8a87-99a6-4ac9-b3e2-a6472f25a38e"></video>
<br>
1st person view:
<video src="https://github.com/user-attachments/assets/1be7194d-0522-41c0-af4a-9afb16968212"></video>
<br>
As you can see, my player character is a Red Bean(sigma character design) and the desired surface to be walked on is an <a href="https://threejs.org/docs/scenes/geometry-browser.html#IcosahedronGeometry">Icosphere</a>, the red tracks left behind is the path taken by the player character when traversing the icosphere surface.
<h1>How the algorithm works</h1>
As stated before the first step is putting the player character on a face of the mesh, in case of 3d models imported into Godot 4, every face is a triangle, so you are bascially putting your player character on a given mesh triangle in the beginning, the depending on the direction you want your player to move, a plane parallel to that direction is created, Now when you scanned the mesh in the beginning, the data about traingles(mesh faces) was stored in the cfg. The data is in the form of a dictionary in which each key is the index of a face and each value is am array of size 3 containing another array of size 2 in which the first entry is the index of the traingle adjacent to an edge and the second entry is the index of the edge to which the corresponding triangle is adjacent to. This data is needed to figure out the 3 adjacent triangles to a certain face(also a triangle) of the walking surface.
<br>
<br>
Once the player character is on a face, the main algorithm can begin, you need to supply the WalkOnSortedSurface class with the reference node, a MeshDataTool class instance, the face which the player is currently on, the string name of the direction in which the player wishes to move, and the distance  by which the player is to move, starting from the current location, giving you the info about the next point and the path to be travelled. Then you cal pass all that info to the  WalkOnSortedSurface class again to get the final travelling location along with the new player <a href="https://docs.godotengine.org/en/stable/classes/class_basis.html">Basis</a>. This can be run in a loop so that player input can dictate how the player moves on the walking surface.
<br>
<h3>Working Principle</h3>
After putting the player on a face the direction plane(plane parallel to a direction) is used to see if any of the edges of the current triangle are intersecting the plane, the edge intersecting the plane is taken as the current edge and the face adjacent to that edge is then checked for intersections with the same plane, this is continued till the path formed by the intersections is as long as required.
<br>
<br>
You can see how the intersection of the triangle's edges with the direction plane(plane parallel to a direction) is used to trace the path in that direction, you can see how each consecutive triangle is checked in all of the 8 directions:
<video src="https://github.com/user-attachments/assets/5f859e4d-02c6-4f2c-b8bc-b3e64aada321"></video>
<br>
You can see how the player moves on the surface, sort of scanning each face:
<video src="https://github.com/user-attachments/assets/c26e5c9d-6f7d-40eb-b3f9-16ffc17c8d53"></video>
<br>
You can replace the walking mesh with any other mesh by going through the procedure mentioned above:

<h1>Resources</h1>