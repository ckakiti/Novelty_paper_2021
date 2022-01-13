# Processing novelty data (Akiti et al. 2021)

Data used in Akiti et al. 2021 available upon request - akiti (at) g (dot) harvard (dot) edu. Data structure is explained [here](https://github.com/ckakiti/Novelty_paper_2021/blob/main/DataStructure.md). The following gives an overview of the code that produced each figure, with descriptions organized either [by code](https://github.com/ckakiti/Novelty_paper_2021/blob/main/README.md#organized-by-code) or [by figure](https://github.com/ckakiti/Novelty_paper_2021/blob/main/README.md#organized-by-figure). Specifics for running each piece of code can be found in the comments within the code itself.

## Organized by code

### [analy_novelty2103.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/analy_novelty2103.m)
- Description: creates bout_multi.mat (needed to make colorplots), and portions of Figures 1-4
- Input: akiti_miceID_210318.xlsx, DLC_label.mat
- Output: 
  - bout_multi.mat
  - colorplots (Fig 1e-g, Fig 2d-e, Fig 3c/d, Fig 4d/e)
  - violin plots (Fig 2d-e)

### [novelty_comparison_multi_days.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/novelty_comparison_multi_days.m)
- Description: creates line plots and boxplots for Figures 1, 3, and 4
- Input: bout_multi.mat
- Output:
  - Fig 1d
  - Fig 3b, Fig 3c/d (frequency comparison), Fig 3e, Fig 3f
  - Fig 4c, Fig 4d/e (frequency comparison), Fig 4f

### [analy_novelty_multi_sessions_2012.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/analy_novelty_multi_sessions_2012.m)
- Description: creates line plots for Figure 2
- Input: akiti_miceID_210318.xlsx, DLC_label.mat
- Output: 
  - line plots (2a-c)

### [Moseq_DLC_2107.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/Moseq_DLC_2107.m)
- Description:
- Input:
- Output:
  - fig 5b, fig 5c (frequency plots), fig 5f

### [Moseq_DLC_2107_2.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/Moseq_DLC_2107_2.m)
- Description:
- Input:
- Output:
  - fig 5c (colorplots)

### [photometry_novelty_summary.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/photometry_novelty_summary.m)
- Description:
- Input:
- Output:
  - fig 6c

### [novelty_tail_behind_summary.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/novelty_tail_behind_summary.m)
- Description:
- Input:
- Output:
  - fig 6d-i

### [lambda_novelty_2112.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/lambda_novelty_2112.m)
- Description:
- Input:
- Output:
  - fig 7b, fig 8b-d

### [MoSeqSyllablePos_wDLC.m](https://github.com/ckakiti/Novelty_paper_2021/blob/main/primary_code/MoSeqSyllablePos_wDLC.m)
- Description:
- Input:
- Output:
  - supp fig 4

## Organized by figure

### Figure 1
- Fig 1d: novelty_comparison_multi_days
- Fig 1e-g: analy_novelty2103

### Figure 2
- Fig 2a-c: analy_novelty_multi_sessions_2012
- Fig 2d-e: analy_novelty2103

### Figure 3
- Fig 3b: novelty_comparison_multi_days
- Fig 3c/d (colorplots): analy_novelty2103
- Fig 3c/d (frequency comparison): novelty_comparison_multi_days
- Fig 3e/f: novelty_comparison_multi_days

### Figure 4
- Fig 4c: novelty_comparison_multi_days
- Fig 4d/e (colorplots): analy_novelty2103
- Fig 4d/e (frequency comparison): novelty_comparison_multi_days
- Fig f: novelty_comparison_multi_days

### Figure 5
- Fig 5b: Moseq_DLC_2107
- Fig 5c (colorplots): Moseq_DLC_2107_2
- Fig 5c (frequency plots): Moseq_DLC_2107
- Fig 5e:
- Fig 5f: Moseq_DLC_2107

### Figure 6
- Fig 6c: photometry_novelty_summary
- Fig 6d-i: novelty_tail_behind_summary

### Figure 7
- Fig 7b: lambda_novelty_2112

### Figure 8
- Fig 8b-d: lambda_novelty_2112

### Supplementary Figure 2
- novelty_comparison_multi_days

### Supplementary Figure 3
- 

### Supplementary Figure 4
- MoSeqSyllablePos_wDLC
