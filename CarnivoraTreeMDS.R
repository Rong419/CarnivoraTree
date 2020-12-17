# This R script performs MultiDimensionalScaling for phylogenetic trees of Carnivora data set.
# The MDS compares the distances of trees sampled by BEAST2 in 6 scenarios, including
# (1) BDSS tree prior + fixed tree topology + fixed BDSS parameters
# (2) BDSS tree prior + sampling treee topology + fixed BDSS parameters
# (3) BDSS tree prior + sampling treee topology + sampling BDSS parameters
# (4) BDSS tree prior + sampling treee topology + sampling BDSS parameters + clade constraits
# (5) FBD tree prior + sampling treee topology + sampling FBD parameters
# (6) FBD tree prior + sampling treee topology + sampling FBD parameters + clade constraits


source('CarnivoraAnalysisUtils.R')

main.path <- "./"

## (1) scenario settings
### the number of trees to extract from the sampled trees in MCMC 
tree.nr <- 100
### tree prior models 
tree.prior <- c("BDSS", "BDSS", "BDSS", "FBD", "FBD")
### analysis category -> consistent with folder path and files names to corresponding .trees files
category <- c("fixedparams", "sampleparams", "constraints", "sampleparams", "constraints")

## (2) get the sampled in 5 scenarios
### get the results of fixed tree analysis
tree0 <- read.nexus(file = paste0(main.path, "CarnivoraMorphMolec.trees"))
samples0 <- tree0[seq(length(tree0) * 0.1, length(tree0), length = tree.nr)]

### get the results of sampling tree analysis
idx <- 1
samples <- samples0
for (prior in tree.prior) {
  # read the output .trees file from BEAST2
  assign(paste0("tree", idx), read.nexus(file = paste0(main.path, "/MorphMolec_", prior, "_",category[idx], ".trees")))
  
  # extract certain number of trees from the sampled trees
  assign(paste0("samples", idx), get(paste0("tree", idx))[seq(length(tree1) * 0.1, length(tree1), length = tree.nr)])
  
  # combine the extracted trees
  samples = c(samples, get(paste0("samples", idx)))
  
  # go to the next scenario
  idx = idx + 1
}

## (3) calculate the tree distances under four measurement
### initializing matrix for tree distances
### including RF.distance, branch.score.difference, path.difference, weighted.path.difference
rf.dis <- matrix(0, ncol = tree.nr * idx, nrow = tree.nr * idx)
branch.score <- matrix(0, ncol = tree.nr * idx, nrow = tree.nr * idx)
path.diff <- matrix(0, ncol = tree.nr * idx, nrow = tree.nr * idx)
weighted.path.diff <- matrix(0, ncol = tree.nr * idx, nrow = tree.nr * idx)

### populate the pairwise distances
for (i in 1:(tree.nr * idx - 1)){
  for (j in (i+1):(tree.nr * idx)){
    # calculate the four measurement between any two trees
    distances = treedist(samples[[i]], samples[[j]])
    rf.distance = as.numeric(distances[1])
    bs.distance = as.numeric(distances[2])
    pd.distance = as.numeric(distances[3])
    wpd.distance = as.numeric(distances[4])
    
    rf.dis[i,j] =  rf.distance
    rf.dis[j,i] = rf.distance
    
    branch.score[i,j] =  bs.distance
    branch.score[j,i] = bs.distance
    
    path.diff[i,j] =  pd.distance
    path.diff[j,i] = pd.distance
    
    weighted.path.diff[i,j] =  wpd.distance
    weighted.path.diff[j,i] = wpd.distance
  }
}

## (4) perform the MDS for the four pairwise distance matrix
### ratio -> 0.1768415, interval -> 0.1496453, mspline -> 0.109992  
tree_mds_1 = mds(delta = rf.dis, ndim = 2, type = "mspline")

### ratio -> 0.2635375, interval -> 0.1994696, mspline -> 0.1895272
tree_mds_2 = mds(delta = branch.score, ndim = 2, type = "mspline")

### ratio -> 0.2073283, interval -> 0.1591655, mspline -> 0.108082
tree_mds_3 = mds(delta = path.diff, ndim = 2, type = "mspline")

### ratio -> 0.1414657, interval -> 0.1001148, mspline -> 0.09680041
tree_mds_4 = mds(delta = weighted.path.diff, ndim = 2, type = "mspline")

## (5) make figures
model.description = c(rep("1", tree.nr), rep("2", tree.nr), rep("3", tree.nr), rep("4", tree.nr), rep("5", tree.nr), rep("6", tree.nr))
col.values = c("firebrick4", "dimgray", "darkviolet", "darkorange2", "dodgerblue3", "seagreen4")
shp.values = c(16, 17, 15, 5, 3, 8)

rf.fig <- get.arrow.mds.plot(tree_mds_1$conf, model.description, "(a) Robinson-Foulds distance", col.values,  shp.values, c(-0.8, -0.2), c(-1, -0.25, -1.15, -0.3), -1, 1, -0.5, 0.5)
bs.fig <- get.rect.mds.plot(tree_mds_2$conf, model.description, "(b) Branch score difference", col.values,  shp.values, c(0.95, -1.1), c(-0.2, 1.4, -1.2, -0.3), -1, 1, -1, 1.5)

pd.fig <- get.arrow.mds.plot(tree_mds_3$conf, model.description, "(c) Path difference", col.values, shp.values, c(-0.65, -0.17), c(-0.8, -0.21,-0.9, -0.28), -1, 1, -0.4, 0.4)
wpd.fig <- get.rect.mds.plot(tree_mds_4$conf, model.description, "(d) Weighted path difference", col.values, shp.values, c(1, -0.6), c(-0.7, 1.5, -0.7, -0.3), -1, 1, -0.5, 1.0)

main.tex.figure <- ggarrange(rf.fig, bs.fig, pd.fig, wpd.fig, nrow = 2, ncol = 2, common.legend = TRUE, legend = "right")

## (6) export figures
options(tikzMetricPackages = c("\\usepackage[utf8]{inputenc}",
                               "\\usepackage[T1]{fontenc}", "\\usetikzlibrary{calc}",
                               "\\usepackage{amssymb}"))
tikz(paste0(main.path, "MDSTreeDistances.tex"), width = 10, height = 10, standAlone = TRUE,
     packages = c("\\usepackage{tikz}",
                  "\\usepackage[active,tightpage,psfixbb]{preview}",
                  "\\PreviewEnvironment{pgfpicture}",
                  "\\setlength\\PreviewBorder{0pt}",
                  "\\usepackage{amssymb}"))

par(mar = c(4,4,4,4))
main.tex.figure
dev.off()

