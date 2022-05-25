import sys
from datetime import datetime, date
import os

current_time = datetime.now().strftime("%H:%M:%S")
today = date.today()
print(f"it is currently: {current_time}")

if len(sys.argv) > 1:
    comment = ' '.join(sys.argv[1:])

else:
    comment = f"commit on {today} - {current_time} by {os.getlogin()}"
    custom = input("Enter a commit comment (optional): ")

    if custom != "":
        comment = custom

os.system('git add .')
os.system(f'git commit -m "{comment}"')
os.system('git push')

_ = input("Press any key to close the program.....")