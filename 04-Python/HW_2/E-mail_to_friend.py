recipient = input("Enter name of your friend, please: ")
name = input("Enter your name, please: ")
age = input ("Enter your age, please: ")
city = input("There are you from? ")
profession = input("Enter your profession, please: ")
become = input("Enter your future profession, please: ")
requirements = input("Enter requirments for your future profession, please: ")
flatmate = input("Enter your flatmate, please: ")
flatmate_prof = input("Enter your flatmate profession, please: ")
hobby = input("Enter your hobby, please: ")
question = input("Enter your question to friend, please: ")
wishes = input("Enter your wishes, please: ")

#Body of e-mail

#Old style formatting
print("Hello, %s!" %recipient)
print("My name is %(my_name)s. I'm %(my_age)s years old. I am from %(my_city)s." %{"my_name": name, "my_age": age, "my_city": city})

#New style formatting
print("I am a/an {}. I'm dreaming to be {}. This profession requires {}." .format(profession, become, requirements))
print('I am living with {roommate}, he/she is {roommate_prof}.'.format(roommate = flatmate, roommate_prof = flatmate_prof))


#f-Strings formatting
print(f"My hobby is {hobby}. And {question}. {wishes}")




