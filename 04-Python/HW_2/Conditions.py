import random


#The game of guessing the number. Number generates by pseudorandom generator 
puzzle = random.randrange(1,1000)

answer = input("Enter the number, please: ")

if  answer == puzzle:
    print ("Yes, you  are right.")
else:
    print ("No, you are wrong! The answer is ", puzzle)

print('==================== Next Section ====================')


#Ages' definition game
age = int(input("Enter your age, please: "))

if age <= 4:
   print("You are too young!!!")
elif age > 4 and age < 12:
    print("You are child.") 
elif age>= 12 and age < 19:
    print("You are teenager.")
else:
    print("You are too old!")

print('==================== Next Section ====================')

teams = ['Senators', 'Rangers', 'Kraken', 'Ducks', 'Capitals', 'Golden Knights']
WesternConf = ['Kraken', 'Ducks', 'Golden Knights']


#Searching team in teams' list
franchise = input("Enter team name, please: ")

if franchise in teams:
    print(f"Yes, {franchise} are in teams' list!")
else:
    print (f"Sorry, {franchise} aren't in team list...")


#We make sure that teams are in Western Conference

for trademark in teams:
    if trademark == franchise:
       if trademark in WesternConf:
            print(trademark + " are in Western Conference!")
            break
       else:
            print(trademark + " aren't in Western Conference!")
            break
    else:
        continue
