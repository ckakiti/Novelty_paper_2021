# Processing novelty data (Akiti et al. 2021)

Data used in Akiti et al. 2021 can be found at LOCATION_OF_DATA. Data structure is explained [here](https://github.com/ckakiti/Novelty_paper_2021/blob/main/DataStructure.md). The following gives an overview of the code that produced each figure. Specifics for running each piece of code can be found in the comments within the code itself.

## Figures 1-4

### Figure 1. [Plot_compare_trim.m](https://github.com/ckakiti/Novelty_paper_2021/blob/master/FurtherAnalysis/Plot_compare.m)
- plotting different scalar statistics across sessions and mice (e.g. time spent around object, orientation, bout num, bout len, total  distance run, area covered)
- Input: 
- Output: timeNearObj_10min.tif (Fig 1d)

### 2. [bout_analysis.m](https://github.com/ckakiti/Novelty_paper_2021/blob/master/FurtherAnalysis/bout_analysis.m)
- similar to TimeStatistic, create summary array of number of bouts and average bout length across sessions and days
- can also create structure containing frame numbers for each poke and approach (needed for MoSeqEventAlignedAnalysis.m)
- Input: Config_NovAna, MiceIndex, .mat files from Analysis.m
- Output: boutAnalysis_nose.csv, PokesApproaches.mat, DatasetName_poke_labels_N1.csv

### 3. video_novelty_multi_labels_2011.m (Mitsuko code)
- creates DLC_label.mat (containing Labels and session_start)
- Input: akiti_miceID_210318.xlsx (animal name, group, condition), ArenaObjPos.m, DLC csv file
- Output: DLC_label.mat

### 4. analy_novelty2103 (Mitsuko code)
- creates bout_multi.mat (needed for plotting multi-day behavior imagesc)
- Input: akiti_miceID_210318.xlsx, ArenaObjPos.mat, DLC_label.mat
- Output: GROUPNAME_analy_novelty2103_ka.mat, bout_multi.mat, imagesc behavior plots (approach w tail behind/exposure, approach freq, etc)

### 5. analy_novelty_multi_sessions_2012 (Mitsuko code)
- creates distToObj, nose-tail, and bout plots for multiple mice and sessions, avg of avg plots + heatmaps, fits exponential to avg of avg curves
- Input: Config_NovAna, MiceIndex.mat, DLC_label.mat (generated by video_novelty_multi_labels_2011.m)
- Output: 
  - bout_early_late.tif, distToObj_nose-tail.tif, distToObj.tif, nose-Tail.tif
  - bout_nose_tail_all
  - noseTailAvgOfMean.tif, noseTailAvgOfMean_sep.tif, noseTailHeatmap_mean.tif
  - exponential fit plots + statistics

## Figure 5

### 1. filename
- description
- Input: 
- Output: 

## Figure 6

### 1. photometry_novelty_Korleki_2105.m (Mitsuko code)
- required supplementary code:
  - analyze_noise_2105_novelty
  - photometry_sync_every10_2105
  - videosync_every10_2105
- Input: akiti_miceID_210318.xlsx, DLC_label.mat
- Output: ANIMAL_FPaligned_SESSION.tif

### 2. [KW_1_LED.m](https://github.com/ckakiti/Novelty_paper_2021/blob/master/FurtherAnalysis/KW_1_LED.m)
- use detect_video_LED_2010.m instead
- extract frames when LED was on (in rgb video)
- NOTE: TAKES A LONG TIME TO RUN
- Input:
  - video file (.mp4/.avi)
  - ArenaObjPos.mat (from MarkObjPos.m, containing LED position)
- Output: 
  -  save_###/save_###_max (pixel intensity for each frame of video - takes a while to run)
  -  LED_on (onset of LED flash across video)

### 3. [FPdat_import.m](https://github.com/ckakiti/Novelty_paper_2021/blob/master/FPdat_import.m)
- read and save raw photometry signal (generated by custom program)
- Input:
  - LED_on (from KW_1_LED.m)
  - FP analog data file (generated by custom program, either .dat or no extension)
- Output:
  - mouse_date_FP.mat (containing GCaMP, tdTom, TTL, TTL_on, pos_within_TTL)
  - mouse_date_rgb_ts (containing rgb indices and corresponding FP indices)

### 4. [bout_analysis.m](https://github.com/ckakiti/Novelty_paper_2021/blob/master/FurtherAnalysis/bout_analysis.m) OR hand-annotate
- annotate rgb/depth video with significant events (e.g. pokes, bout start, reward delivery)
- Input: Config_NovAna, MiceIndex, .mat files from Analysis.m
- Output: PokesApproaches.mat, DatasetName_poke_labels_N1.csv

## Figures 7-8

### 1. filename
- description
- Input: 
- Output: 
