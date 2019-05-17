#GFG Code Challenge 
file = open("bigfile",'r')
data = file.read()
lines = data.splitlines()

# 1 count lines OK
numoflines = len(lines)
print ("Number of Lines:",numoflines)

#2 count number fo lines with text TEST and TERRY in field 12
countword = 0
result=[]
for line in lines:
    field12 = line.split('\t')[11]
    if field12 == 'TEST' or field12 == 'TERRY':
        countword += 1
print("Number of lines with TEST and TERRY:", countword)

#3 Create a new file holding the first 100 lines of the original text file
hundred = lines[0:100]
to_file = '\n'.join(hundred)
outfile = open("question3.txt", "w")
outfile.write(to_file)
outfile.close()

#4 Create a new tab-separated file holding fields 3, 6 and 13 from all lines in the original
result1=[]
outfile3 = open("question4.txt", "w")
for line in lines:
    field3  = line.split('\t')[2]
    field6  = line.split('\t')[5]
    field13 = line.split('\t')[12]
    outfile3.write('\t'.join([field3, field6, field13]) + '\n')
outfile3.close()

#5 Create a new file which holds only even lines (2, 4, 6, etc.) from the original
i = 1
outfile2 = open("question5.txt", "w")
for line in lines:
    if i % 2 == 0 :
        outfile2.write(line + '\n')
    i += 1
outfile2.close()

#6 Count the number of lines where the numeric field 4 is between 100 and 400
count=0
for line in lines:
    field4  = line.split('\t')[3]
    if field4 > 100 and field4 < 400:
        count+=1
print("Number of lines where field 4 is between 100 and 400", count)
file.close()
