import sys
sys.set_int_max_str_digits(0)

input = list(map(int, input().split()))

income = input[0]
investors_count = input[1]
days = input[2]

while days > 0:
  i = 9
  while i >= 0:
    new_income = int(str(income) + str(i))

    if new_income % investors_count == 0:
      if i == 0:
        income *= pow(10, days)
        i = -2
        break

      income = new_income
      break

    i -= 1

  if i == -1:
    income = -1
    break
  elif i == -2:
    break

  days -= 1

print(income)
