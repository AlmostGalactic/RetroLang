//Choose your adventure game
//This is a simple text-based adventure game where the player can explore different rooms, pick up items, and interact with objects.

//Imports
DEC strLib = IMPORT "libs/strLib.rl"

//Define rooms
DEC rooms = [
    LivingRoom = [
        description = "You are in a cozy living room. There is a sofa and a TV.",
        items = ["remote", "book"],
        exits = ["Kitchen", "Bedroom", "Upstairs"]
    ],
    Kitchen = [
        description = "You are in a kitchen. There is a fridge and a stove.",
        items = ["knife", "apple"],
        exits = ["LivingRoom", "Garage"]
    ],
    Bedroom = [
        description = "You are in a bedroom. There is a bed and a wardrobe.",
        items = ["pillow", "blanket"],
        exits = ["LivingRoom", "Bathroom"]
    ],
    Bathroom = [
        description = "You are in a bathroom. There is a shower and a sink.",
        items = ["soap", "towel"],
        exits = ["LivingRoom", "Bedroom"]
    ],
    Garage = [
        description = "You are in a garage. There is a car and some tools.",
        items = ["wrench", "oil"],
        exits = ["LivingRoom", "Kitchen", "Basement"]
    ],
    Basement = [
        description = "You are in a basement. There is a furnace and some boxes.",
        items = ["flashlight", "batteries"],
        exits = ["Garage"]
    ],
    Attic = [
        description = "You are in an attic. There is a trunk and some old furniture.",
        items = ["old book", "photo"],
        exits = ["Upstairs"]
    ],
    Upstairs = [
        description = "You are upstairs. There are two doors: one to the left and one to the right.",
        items = ["key", "map"],
        exits = ["LivingRoom", "Attic"]
    ]
]
//Define player state
DEC player = [
    currentRoom = "LivingRoom",
    inventory = []
]
//Function to display the current room description
FN displayRoom()
    DEC room = rooms[player.currentRoom]
    print(room.description)
    print(concat(concat("Items in current room: ", char(10)), strLib.table.concat(room.items, ", ")))
STOP
//Function to display the player's inventory
FN displayInventory()
    IF len(player.inventory) == 0 DO
        print("Your inventory is empty.")
    ELSE
        print(concat(concat("Your inventory: ", char(10)), strLib.table.concat(player.inventory, ", ")))
    STOP
STOP
//Function to move to a different room
FN moveToRoom(roomName)
    DEC room = rooms[player.currentRoom]
    IF inTable(roomName, room.exits) DO
        set(player, "currentRoom", roomName)
        print(concat("You move to the ", roomName, "."))
        displayRoom()
    ELSE
        print(concat("You can't go to the ", roomName, "."))
    STOP
STOP
//Function to pick up an item
FN pickUp(itemName)
    DEC room = rooms[player.currentRoom]
    IF inTable(itemName, room.items) DO
        push(player.inventory, itemName)
        pop(room.items, itemName)
        print(concat("You picked up the ", concat(itemName, ".")))
    ELSE
        print(concat("There is no ", itemName, " here."))
    STOP
STOP

//Function to get user command in terminal
FN getCommand()
    DEC command = get(concat(char(10), "What do you want to do? "))
    RETURN command
STOP

FN runCommand(command)
    DEC parts = split(command, " ")
    DEC action = parts[1]
    DEC target = parts[2]

    IF action == "look" DO
        displayRoom()
    ELSEIF action == "inventory" DO
        displayInventory()
    ELSEIF action == "go" DO
        moveToRoom(target)
    ELSEIF action == "pick" DO
        pickUp(target)
    ELSEIF action == "quit" DO
        print("Thanks for playing!")
        RETURN false
    ELSEIF action == "exits" DO
        DEC room = rooms[player.currentRoom]
        print(concat("Exits: ", strLib.table.concat(room.exits, ", ")))
    ELSE
        print("Unknown command.")
    STOP
    RETURN true
STOP

//Main game loop
FN main()
    print("Welcome to the Adventure Game!")
    displayRoom()
    DEC playing = true
    WHILE playing DO
        DEC command = getCommand()
        playing = runCommand(command)
    STOP
STOP
main()