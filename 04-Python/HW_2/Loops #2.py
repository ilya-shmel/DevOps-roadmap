first = input("Enter first number, please: ")
second = input("Enter second number, please: ")
third = input("Enter third number, please: ")

#Даны три числа. Вывести на экран «yes«, если среди них есть одинаковые, иначе вывести “ERROR”

numbers = [first, second, third]

index = 2
match = False
while index > -1:
   index -= 1
   if numbers[index] == numbers[index+1]:
       match = True
       
if match == True:
    print ('yes')
else:
    print('ERROR')

print('==================== Next Section ====================')

#Даны три числа. Вывести на экран «yes«, если можно взять какие-то два из них и в сумме получить третье

sum = 0
index = 0 

for index in range(0, 3, 1):
    sum = sum + int(numbers[index])

for number in numbers:
    if (sum - int(number)) == int(number):
        print('yes')
        break     
    else:
        print ("On " + str(number) + " no matches")

    


