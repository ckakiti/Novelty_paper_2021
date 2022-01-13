# Data structure
DLC data is stored in .mat files. Given .mat files were renamed based on the following file structure:

```
.
+-- group1_name
|   +-- animal1_name
|       +-- session1_name
|           -- DLC_label.mat
|       +-- session2_name
|       +-- session3_name
|   +-- animal2_name
|   +-- animal3_name
|   -- bout.mat
|   -- bout_multi.mat
+-- group2_name
+-- group3_name
-- akiti_miceID_211222.xlsx
```

There is a separate .mat file for each session. DLC_label.mat contains the variable "Labels" which as the following format:
```
Labels(:,2) Nose x (pixel)
Labels(:,3) Nose y (pixel)
Labels(:,5) Leftear x (pixel)
Labels(:,6) Leftear y (pixel)
Labels(:,8) Rightear x (pixel)
Labels(:,9) Rightear y (pixel)
Labels(:,11) Tailbase x (pixel)
Labels(:,12) Tailbase y (pixel)
Labels(:,14) Tailmidpoint x (pixel)
Labels(:,15) Tailmidpoint y (pixel)
Labels(:,17) Tailtip x (pixel)
Labels(:,18) Tailtip y (pixel)
Labels(:,20) Head x (pixel) 'average of nose, leftear and rightear'
Labels(:,21) Head y (pixel)
Labels(:,22) Body x (pixel) 'average of head and tail base'
Labels(:,23) Body y (pixel)
Labels(:,24) Tail x (pixel) 'average of tailtip, midpoint and base'
Labels(:,25) Tail y (pixel)
Labels(:,26) head speed (pixel)
Labels(:,27) head accerelation (pixel)
Labels(:,28) head jerk (pixel)
Labels(:,29) body speed (pixel)
Labels(:,30) body accerelation (pixel)
Labels(:,31) body jerk (pixel)
Labels(:,32) nose distance from object (pixel)
Labels(:,33) head distance from object (pixel)
Labels(:,34) tailbase distance from object (pixel)
Labels(:,35) body length (pixel)
Labels(:,36) head speed related to object (pixel)
Labels(:,37) head speed unrelated to object (pixel)
Labels(:,38) tail-base from wall (pixel)
```

MoSeq data is stored in `MoSeq_MiceIndex_wLabels_combine3L.mat`.

Photometry data is stored in files named `*approach_start.mat`, `*retreat.mat`, and `*retreat_end.mat` (3 files for the first day of novelty for each animal). Information about each mouse is stored in akiti_miceID_211222.xlsx. 
