// Very weird calculator but with >LeTtErS<

DEC first = get("Enter the first letter to add")
DEC second = get("Enter the second letter to add")

DEC firstnum = getAscii(first)-64
DEC secondnum = getAscii(second)-64

DEC result = char(64+(firstnum+secondnum))
print(result)