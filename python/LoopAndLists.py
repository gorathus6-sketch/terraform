# Loop and List Drills

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

for n in numbers:
    if n % 2 == 0:
        print(n)

#
# or it can be written as a list comprehension:
#
# evens = [n for n in numbers if n % 2 == 0]
# print(evens)
#