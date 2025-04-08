DEC strLib = IMPORT "libs/strLib.rl"

DEC input = get("Enter some text to MeSs Up!")
print(strLib.mess(input))

DEC table = [1, 2, 3, 4, 5]
print(strLib.tableconcat(table, " "))