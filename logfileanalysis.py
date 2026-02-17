# Initialize an empty dictionary to store counts
status_counts = {}

# Open the file in read mode
with open('server_logs.txt', 'r') as file:
    for line in file:
        # Remove whitespace and split the line by spaces
        parts = line.strip().split(' ')

        # This first item is our status code
        code = parts[0]

        # If the code is already in the dictionary, increment it:
        if code in status_counts:
            status_counts[code] += 1
        # otherwise start count at 1
        else:
            status_count[code] = 1

# Print the final results
for code, count in status_counts.items():
    print(f'Status {code}: {count} occurrences')

try:
    status_counts = {}

    # attempt to open the file
    with open('server_logs.txt', 'r') as file:
        for line in file:
            line = line.strip()
            # skip empty lines
            if not line:
                continue

            parts = line.split(' ')
            code = parts[0]

            # Update the dictionary
            status_counts[code] = status_counts.get(code, 0) + 1

    # print result only if the file is found:
    for code, count in status_counts.items():
        print(f'status {code}: {count} occurrences')

except FileNotFoundError:
    print('Error: The file server_logs.txt was not found.')
exept IndexError:
    print('Error: A line in the file was formatted incorrectly.')
    except Exception as e:
    print(f'An unexpected error occurred: {e}')