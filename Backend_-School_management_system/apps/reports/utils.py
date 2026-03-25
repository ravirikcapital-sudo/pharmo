from datetime import date, timedelta

def get_date_range(time_range):
    today = date.today()

    if time_range == "this_month":
        start = today.replace(day=1)
    elif time_range == "last_3_months":
        start = today - timedelta(days=90)
    elif time_range == "last_6_months":
        start = today - timedelta(days=180)
    elif time_range == "this_year":
        start = today.replace(month=1, day=1)
    else:
        start = today.replace(day=1)

    return start, today