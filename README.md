
# Comparing sampled trees

In this repository, there are 6 .trees files from 6 phylogenetic analysis under different models. Each .trees file contains sampled trees during MCMC chain and has 19 species including 10 extant species and 9 extinct species.

* Analysis 1: CarnivoraMorphMolec.trees (20001 sampled trees)

  BDSS tree prior + sampling divergence times + fixed tree topology + fixed BDSS parameters
  
* Analysis 2: 

  BDSS tree prior + sampling divergence times + sampling tree topology + fixed BDSS parameters 

* Analysis 3:   
  
  BDSS tree prior + sampling divergence times + sampling tree topology + sampling BDSS parameters

* Analysis 4:  

  BDSS tree prior + sampling divergence times + sampling tree topology + sampling BDSS parameters + clade constraints
  
  Clade1 (Caniformia): Ael_sp, Tom_sp, Epi_hay, Par_jos, Enh_pah, Hes_sp, Can_dir, Can_lup, Cuo_alp, Cer_tho, Spe_ven, Oto_meg, Vul_vul, Urs_ame, Ail_ful
  
  Clade2 (Felifomia): Par_her, Hia_won, Smi_fat, Nan_bin

* Analysis 5:

  FBD tree prior + sampling divergence times + sampling tree topology + sampling FBD parameters

* Analysis 6:
 
  FBD tree prior + sampling divergence times + sampling tree topology + sampling FBD parameters + clade constraints

  Clade1 (Caniformia): Ael_sp, Tom_sp, Epi_hay, Par_jos, Enh_pah, Hes_sp, Can_dir, Can_lup, Cuo_alp, Cer_tho, Spe_ven, Oto_meg, Vul_vul, Urs_ame, Ail_ful
  
  Clade2 (Felifomia): Par_her, Hia_won, Smi_fat, Nan_bin
  
## Visualizing tree distance using multidimensional scaling 

The following command line runs the R script and produces MDSTreeDistances.tex file that further generates MDSTreeDistances.pdf.
```
Rscript CarnivoraTreeMDS.R
```

The script compares tree distances according to the procedure detailed below.

### (1)
Extract 100 trees uniformly from each of the 6 .trees files so that we get 600 trees in total.

### (2)
Calculate the pairwise tree distances among the 600 trees. There are four measurements used to represent the distance between trees, including 

(a) Robinson-Foulds distance: comparing tree topologies

(b) Branch score difference: comparing branch length in time

(c) Path difference: comparing number of edges between species

(d) Weighted path difference: comparing number of edges weighted by the branch length in time between species

As a result, we get 4 matrices corresponding to the four measurements and each matrix is a $600 \times 600$ symmetric matrix.

### (3)
Perform multidimensional scaling (MDS) to visualize the distance matrix. Namely, MDS transforms a $600 \times 600$ matrix into 600 2-dimensional coordinates.





