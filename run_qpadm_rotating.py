#!/usr/bin/env python3

import argparse
from multiprocessing import Pool
from itertools import combinations
import os
import sys
import random

parser = argparse.ArgumentParser(description="Automatically run qpAdm in two- and three- way admixture model using a source population panel.")
parser.add_argument("target", help="Target population")
parser.add_argument("source", help="Panel of source populations")
parser.add_argument("outgroup", help="Path of outgroup list")
parser.add_argument("--num", help="The number of admixture model (2, 3 or 4 way ..). Default run 2 way model at most.", type=int, default=2)
parser.add_argument("--name", default="", help="Prefix of files")
parser.add_argument("--jobs", default=1, help="Number of jobs in one run", type=int)
args = parser.parse_args()

tg = args.target
source = args.source
out = args.outgroup
name = args.name
num = args.num
jobs = args.jobs

with open(source) as f: 
    source_list = [i.strip() for i in f if i.strip()!='' and i[0]!="#" and i.strip()!=tg]
with open(out) as f:
    out_list = [i.strip() for i in f if i.strip()!='' and i[0]!="#"]

job_list = []

def run(par, log):
    os.system("qpAdm -p {} > {}".format(par, log))
    return(0)

def make_par(tg, source_list, n, out):
    for i in combinations(source_list, n):
        right = [i for i in out]
        for j in source_list:
            if not j in i:
                right.append(j)
        left_name = "{}{}_{}.left".format(name, tg, ''.join(i))
        right_name = "{}{}_{}.right".format(name, tg, ''.join(i))
        par_name = "{}{}_{}.par".format(name, tg, ''.join(i))
        log_name = "{}{}_{}.log".format(name, tg, ''.join(i))
        with open(left_name, 'w') as f:
            f.write("{}\n".format(tg))
            f.write("\n".join(i))
        with open(right_name, 'w') as f:
            f.write("\n".join(right))
        with open(par_name, 'w') as f:
#genotypename: /public/adna/jingkun_ran/data/UPA34_a.geno
#snpname: /public/adna/jingkun_ran/data/UPA34_a.snp
#indivname: /public/adna/jingkun_ran/data/UPA34_a.ind
            f.write('''
genotypename: /public/adna/jingkun_ran/data/UPA34_a.geno
snpname: /public/adna/jingkun_ran/data/UPA34_a.snp
indivname: /public/adna/jingkun_ran/data/UPA34_a.ind
popleft: {}
popright: {}
details: YES
allsnps: YES'''.format(left_name, right_name))
        job_list.append([par_name, log_name])
    return(0)

if num == 2:
    if num > len(source_list):
        num = len(source_list)
    for n in range(1, num+1):
        make_par(tg, source_list, n, out_list)
else:
    make_par(tg, source_list, num, out_list)

#pool = Pool(200)
#pool.starmap(run, job_list)
#pool.close()
#pool.join()

#for j in job_list:
#    cmd = "qpAdm -p {} > {}".format(j[0], j[1])
#    wd = os.getcwd()
#    fn = "{}_qpadm_{}{}_{}.sh".format(tg, random.randint(1, 99), random.randint(1,99), name)
#    with open(fn, 'w') as f:
#        f.write('''
#!/bin/bash
#PBS -l nodes=1:ppn=1   #ppn=cpu numbers needed for per task
#PBS -q low
#PBS -d .        

#cd {}
#{}
#'''.format(wd, cmd))
#    os.system("qsub {}".format(fn))

cmds = ["qpAdm -p {} > {}".format(j[0], j[1]) for j in job_list]
x = len(cmds) // jobs
y = len(cmds) % jobs
wd = os.getcwd()
for i in range(0, x+1):
    fn = "{}_qpadm_{}{}_{}.sh".format(tg, random.randint(1, 99), random.randint(1,99), name)
    if i*jobs+y != len(cmds):
        bash_cmd = "\n".join(cmds[i*jobs:(i+1)*jobs])
    else:
        #能不能整除的处理方法是不一样的
        if y != 0:
            bash_cmd = "\n".join(cmds[i*jobs:])
        else:
            bash_cmd = ''
    with open(fn, 'w') as f:
        f.write('''
#!/bin/bash
#PBS -l nodes=1:ppn=1   #ppn=cpu numbers needed for per task
#PBS -q low
#PBS -d .        

cd {}
{}
'''.format(wd, bash_cmd))
    os.system("qsub {}".format(fn))
print("Finish all.")
sys.exit(0)