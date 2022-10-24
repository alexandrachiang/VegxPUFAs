#Compare our numbers with Michael's

#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
#suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

source('/scratch/ahc87874/Fall2022/pheno/load_UKBphenotables.R')
ukbnames <- read.csv("ukbnames.csv")

names(bd) <- ukbnames

