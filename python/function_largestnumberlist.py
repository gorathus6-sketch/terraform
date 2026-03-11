# function that returns the largest number in a list

def max_value(nums):
    largest = nums[0]
    for n in nums:
        if n > largest:
            largest = n
    return largest

print(max_value([3, 9, 1, 7]))