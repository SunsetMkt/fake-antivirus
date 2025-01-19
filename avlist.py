oneline = "@("

with open("avlist.txt") as f:
    for line in f:
        oneline += '"' + line.strip() + '",'

oneline = oneline[:-1] + ")"

print(oneline)
