Using Godot v4.2.1 stable
<br>
The project aims to provide a method to let your player character(a 3D model) to walk on any 3D mesh with "clean geometry"(more on this later).
<br>
<h1>How to Set Up</h1>
First you will need a 3d mesh which is supposed to be walked on by a player character, then you will need the player character itself which will be another 3D model ehich should be standing upright, and any node which will be used as a reference to the player characters basis(this is intended to make lerping more smooth when the player walks on another mesh's surface).
<br>
The initial step for setting up the surface traversal will be a "scan" of the surface. The surface(the player will be walking on) or the 3D model of the walking ground needs to have "clean geometry", what that means is that each triangle on the model needs to have no less than 3 traingles around it, each adjacent to to its edges, bascially the model needs to be completely connected. To begin the scan you will need the MeshSorter class provded in the project, use the SortMesh() function of the class "scan" the walking surface and store the generated data in a CFG file(you will need this file later).
<br>
Code to "scan" the mesh(icosphere is the walking surface mesh):
<img src="/CodeSnippets/Initailizationcode.png">
<br>
If everything is correct, then this message will appear in the output window:
<img src="/CodeSnippets/OutputMessage.png">
