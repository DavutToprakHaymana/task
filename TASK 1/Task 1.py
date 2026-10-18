# =====================================================================
# Part 1: Algorithm and Tracking
# BLP 105 / BLP 1005 Database Management Systems
# Filename: bolum1.py
# =====================================================================

# ---------------------------------------------------------------------
# Question 1.1: Trace Table
# ---------------------------------------------------------------------
# Trace Table Prepared for the Paper Report:
# | Loop Step | i | numbers[i] | total | result       |
# |-----------|---|------------|-------|--------------|
# | Initial   | - |     -      |   0   | []           |
# | Step 1    | 0 |     4      |   4   | []           |
# | Step 2    | 1 |     7      |   4   | [7]          |
# | Step 3    | 2 |     2      |   6   | [7]          |
# | Step 4    | 3 |     9      |   6   | [7, 9]       |
# | Step 5    | 4 |     5      |   6   | [7, 9, 5]    |
# | Step 6    | 5 |     1      |   6   | [7, 9, 5, 1] |
# | Step 7    | 6 |     8      |  14   | [7, 9, 5, 1] |

numbers = [4, 7, 2, 9, 5, 1, 8]
total = 0
result = []

for i in range(len(numbers)):
    if numbers[i] % 2 == 0:
        total = total + numbers[i]
    else:
        result.append(numbers[i])

print("Question 1.1 Outputs:")
print("Total:", total)
print("Result:", result)
print("-" * 40)


# ---------------------------------------------------------------------
# Question 1.2: Longest Sequence
# ---------------------------------------------------------------------
# PSEUDOCODE:
# START
#   readings = [18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
#   threshold = 22
#   max_sequence = 0
#   current_sequence = 0
#   FOR EACH val IN readings:
#     IF val > threshold THEN:
#       current_sequence = current_sequence + 1
#       IF current_sequence > max_sequence THEN:
#         max_sequence = current_sequence
#       ENDIF
#     ELSE:
#       current_sequence = 0
#     ENDIF
#   ENDFOR
#   PRINT max_sequence
# END

readings = [18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
threshold = 22

max_sequence = 0
current_sequence = 0

for val in readings:
    if val > threshold:
        current_sequence += 1
        if current_sequence > max_sequence:
            max_sequence = current_sequence
    else:
        current_sequence = 0

print("Question 1.2 Output:")
print("Longest consecutive sequence:", max_sequence)
print("-" * 40)


# ---------------------------------------------------------------------
# Question 1.3: Manual Grouping
# ---------------------------------------------------------------------
records = [
    {"student": "Ece", "course": "VTYS"},
    {"student": "Ali", "course": "Yapay Zeka"},
    {"student": "Ece", "course": "Yapay Zeka"},
    {"student": "Can", "course": "VTYS"},
    {"student": "Ali", "course": "VTYS"},
    {"student": "Ece", "course": "Robotik"},
]

course_counts = {}

for row in records:
    course = row["course"]
    if course in course_counts:
        course_counts[course] += 1
    else:
        course_counts[course] = 1

print("Question 1.3 Output:")
print(course_counts)
