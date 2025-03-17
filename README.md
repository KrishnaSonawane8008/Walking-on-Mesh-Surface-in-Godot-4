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
<h1>How it works</h1>
<h1>Resources</h1>