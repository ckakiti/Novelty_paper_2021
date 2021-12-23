# Data structure
DLC data is stored in .mat files. Given .mat files were renamed based on the following file structure:

```
.
+-- group_name
|   +-- animal1_name
|       +-- session1_name
|           -- DLC_label.mat
|       +-- session2_name
|       +-- session3_name
|   +-- animal2_name
|   +-- animal3_name
|   -- bout.mat
|   -- bout_multi.mat
-- akiti_miceID_211222.xlsx
```

There is a separate .mat file for each session. MoSeq data is stored in `MoSeq_MiceIndex_wLabels_combine3L.mat`. Information about each mouse is stored in akiti_miceID_211222.xlsx. 

# DLC-specific preprocessing

follow workflow to [analyze DLC-generated files](https://github.com/ckakiti/Novelty_paper_2021#dlc-workflow)

# MoSeq-specific preprocessing

follow workflow to [analyze MoSeq-generated files](https://github.com/ckakiti/Novelty_paper_2021#moseq-workflow)
