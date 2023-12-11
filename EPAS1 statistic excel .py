#statistic pileup file
import xlsxwriter as xls

pd = '/home/rjk19/data/epas1/'

#input txt file
inputfile = open(pd + 'V2484.epas','r')
#output file
newfile = xls.Workbook(pd + 'V2484.xlsx')
x=''
numA=0
numT=0
numC=0
numG=0
worksheet = newfile.add_worksheet()
num_row = 0
num_col = 0
for raw_line in inputfile:
    eachline = raw_line.strip().split()
    seq = str(eachline[4])
    for i in list(seq):
        if i == 'A' or i == 'a':
            numA += 1;
        if i == 'T' or i == 't':
            numT += 1
        if i == 'C' or i == 'c':
            numC += 1
        if i == 'G' or i == 'g':
            numG += 1
    if numA != 0:
        x = x +str(numA)+'A'
    if numT != 0:
        x = x +str(numT)+'T'
    if numC != 0:
        x = x +str(numC)+'C'
    if numG != 0:
        x = x +str(numG)+'G'
    worksheet.write_string(num_row,num_col,x)
    num_row +=1
    numA=0
    numT=0
    numC=0
    numG=0
    x=''
inputfile.close()
newfile.close()