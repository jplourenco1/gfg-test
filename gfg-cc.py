
file = open("bigfile",'r')
data = file.read()
lines = data.splitlines()

# 1 count lines OK
numoflines = len(lines) #contar linhas
print ("Number of Lines:",numoflines) # check number of lines

#2 count number fo lines with text X and Y in field 12 OK
keyword1 = 'TEST'
keyword2 = 'TERRY'
countword = 0
result=[]
for line in lines:
    field12 = line.split('\t')[11]
    if keyword1 == field12 or keyword2 == field12:
        countword += 1
print("Number of lines with TEST and TERRY:", countword)

#3 Create a new file holding the first 100 lines of the original text file many doubts wtf fields OK
hundred = lines[0:100]
to_file = '\n'.join(hundred)
outfile = open("question3.txt", "w")
outfile.write(to_file)
outfile.close()

#4 Create a new tab-separated file holding fields 3, 6 and 13 from all lines in the original OK
result1=[]
for line in lines:
    field3  = line.split('\t')[2]
    field6  = line.split('\t')[5]
    field13 = line.split('\t')[12]
    result1.append('\t'.join([field3, field6, field13]))
to_file2 = '\n'.join(result1)
outfile3 = open("question4.txt", "a")
outfile3.write(to_file2)
outfile3.close()

#5 Create a new file which holds only even lines (2, 4, 6, etc.) from the original OK
i = 1
outfile2 = open("question5.txt", "a")
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
