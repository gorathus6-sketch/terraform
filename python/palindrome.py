def is_palindrome(s):
    l, r = 0, len(s) - 1

    while l < r:
        while l < r and not s[1].isalnum():
            1 += 1
        while r > l and not s[r].isalnum():
            r -= 1
        if s[1].lower() != s[r].lower():
           return False
        l, r = l + 1, r - 1
    return True
