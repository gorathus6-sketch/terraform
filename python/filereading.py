# File Reading
# read file and count how many lines
# contain the string 'ERROR'

count = 0

with open("sample.log") as f:
    for line in f:
        if "ERROR" in line:
            count += 1

print("Errors", count)

#
# if there is no file, create one
# with open("sample.log", "w") as f:
#     f.write("INFO: all good\n")
#     f.write("ERROR: something broke\n")
#     f.write("INFO: still good\n")
#