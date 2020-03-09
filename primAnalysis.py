#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  5 18:06:00 2020

@author: aco
"""

from __future__ import print_function

import os
import pandas as pd
#import sklearn
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np

import time
import pdb
import pickle
import random
import datetime 

import seaborn as sns 

import prim

import warnings; warnings.simplefilter('ignore')

#%%
in_file = 'allData_tg_psycho.csv'
allData_tg_psycho = pd.read_csv(in_file, sep=',', engine='python')
df_input = allData_tg_psycho.iloc[ :, 5:]

response = allData_tg_psycho.iloc[ :, 1]
positions = (response  <0) #& (response < 5)# | (response  ==9) | (response == 10)
response[positions==False]=0
response[positions]=1
p = prim.Prim(df_input, response, threshold=0, threshold_type=">")

box = p.find_box()
box.show_tradeoff()

plt.show()