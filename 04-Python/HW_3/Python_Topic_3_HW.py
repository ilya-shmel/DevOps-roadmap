import random

#Declare custom exceptions
class TooShortNameException(Exception):
    pass

class WrongAgeException(Exception):
    pass

class NonexistentShootsException(Exception):
    pass

#Declare and print the shopping list
shopping_list = ['hoodie', 'jersey', 'headwear', 'hat', 'knit hat', 't-shirt', 'beanie', 'logo', 'poster']
print(shopping_list)

#Declare the list of shoots
skaters_shoots = []

lottery_final = []

#Create dictionries with information about NHL skaters
skater_oilers = {'name' : "Leon Draizaitl", 'age' : '26', 'birthplace' : "Cologne, DEU", 'shoots': 'Left'}
skater_kraken = {'name' : "Jordan Eberle", 'age' : '31', 'birthplace' : "Regina, SK, CAN", 'shoots': 'Right'}
skater_rangers = {'name' : "Adam Fox", 'age' : '23', 'birthplace' : "Jericho, NY, USA", 'shoots': 'Right'}
skater_toronto = {'name' : "John Tavares", 'age' : '31', 'birthplace' : "Missisauga, ON, CAN", 'shoots': 'Left'}
skater_avalache = {'name' : "Gabriel Landeskog", 'age' : '28', 'birthplace' : "Stockholm, SWE", 'shoots': 'Left'}
new_skater = {'name' : " ", 'age' : ' ', 'birthplace' : " ", 'shoots': ' '}

#Declare the list with skaters dictionaries for functions
skaters = [skater_oilers, skater_kraken, skater_toronto, skater_avalache, skater_rangers]

#Function lottery_prize determines the prize from shopping_list and return the winner name and prize name
#Function uses pseurandomiser
def lottery_prize(prizes):
    winner_name = input("Enter your name, please: ")
    prize_index = random.randrange(0, (len(prizes)-1))
    return winner_name, prizes[prize_index]


#Function players_shoots counts right and left shoots from list of skaters dictionaries.
#Function returns numbers of right and left shoots
def players_shoots(players):
    right_shoots = 0
    left_shoots = 0
    for player in players:
        if player['shoots'] == 'Right':
            right_shoots += 1
        else:
            left_shoots += 1
    return right_shoots, left_shoots

#Function create_skater recieve the dictionary with full keys, but empty items. Function uses input() to fill dictionary items and return dictionary custom_skater
#There is custom exceptions for player's name, age and shoots
def create_skater(custom_skater):
    
    custom_skater['name'] = input("Enter the player's name: ")
    if len(custom_skater['name']) < 5:
        raise TooShortNameException("The name is too short!") 
    
    custom_skater['age'] = input("Enter the player's age: ")
    if (int(custom_skater['age']) < 18) or (int(custom_skater['age']) > 40):
        raise WrongAgeException("The age should be between 17 and 41!")
    
    custom_skater['birthplace'] = input("Enter the player's birthplace: ")
    
    custom_skater['shoots'] = input("Enter the player's shoots: ")
    if (((custom_skater['shoots'] != 'Left') and (custom_skater['shoots'] != 'Right')) and ((custom_skater['shoots'] != 'left') and (custom_skater['shoots'] != 'right'))):
        raise NonexistentShootsException("Shoots must be left or right!")
    
    return custom_skater


#Receive the winner and prize
lottery_final = lottery_prize(shopping_list)
print(f"Dear {lottery_final[0]}! Today you won {lottery_final[1]}!!!")

#Recieve of shoots counts
skaters_shoots = players_shoots(skaters)
print(f"There is {skaters_shoots[0]} right shoots players and {skaters_shoots[1]} left shoots players!")

#Add new player info to list "skaters" by call of function create_skater
skaters.append(create_skater(new_skater))  

print(f"You create new player: {skaters[-1]}")

#Try exception ZeroDivisionError
try:
    x = 10/0
except ZeroDivisionError:
    print('Halted because division by zero!')

#Try exception AsserionError
def assert_function(a=None, b=None):
     assert a or b, 'Set a or b, please!'

assert_function()

#Try to work with exception KeyboardInterrupt
try:
    while True:
        pass
except KeyboardInterrupt:
    print('Iterrupted by user!')