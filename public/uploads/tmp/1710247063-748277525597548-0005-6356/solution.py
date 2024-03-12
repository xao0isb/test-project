from datetime import datetime
import time
import calendar

holidays_count = int(input())
year = int(input())

days_of_week_holidays = {
  0: 0,
  1: 0,
  2: 0,
  3: 0,
  4: 0,
  5: 0,
  6: 0
}
while holidays_count > 0:
  date = input()
  date_split = date.split()
  full_date = date_split[0] + " " + date_split[1][:3] + " " + str(year)
  day_of_week = datetime.strptime(full_date, "%d %b %Y").weekday()

  days_of_week_holidays[day_of_week] = days_of_week_holidays[day_of_week] + 1

  holidays_count -= 1

year_start_with = input()

days_of_week_weekend = days_of_week_holidays

year_start_with_int = time.strptime(year_start_with, "%A").tm_wday

i = 0
while i < 7:
  if ((i == year_start_with_int) or
    (calendar.isleap(year) and (i == year_start_with_int + 1))):
    days_of_week_weekend[i] = 53 - days_of_week_weekend[i]
  else:
    days_of_week_weekend[i] = 52 - days_of_week_weekend[i]
  
  i += 1

min_work_int = min(days_of_week_weekend, key=days_of_week_weekend.get)
max_work_int = max(days_of_week_weekend, key=days_of_week_weekend.get)

min_work_in_day_of_week = calendar.day_name[min_work_int]
max_work_in_day_of_week = calendar.day_name[max_work_int]

print(max_work_in_day_of_week, min_work_in_day_of_week)
