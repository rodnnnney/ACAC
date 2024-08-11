String jsonText = '''

Hey Gemini! Pretend you were a food critic, from the following list of restaurants, recommend me a restaurant:
Do not mention aws_card_match, that is not relevant data for user, do not 
forget to mention the link as well
[
    {
        "restaurant_name": "La Noodle",
        "address_of_restaurant": "1383 Clyde Ave",
        "rating": "3.2",
        "review_num": "132",
        "cusine_type": ["Chinese", "Noodle"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "La_Noodle"
    },
    {
        "restaurant_name": "Friends&KTV",
        "address_of_restaurant": "1430 Prince of Wales",
        "rating": "3.7",
        "review_num": "73",
        "cusine_type": ["Chinese"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "Friends&KTV"
    },
    {
        "restaurant_name": "Gongfu Bao",
        "address_of_restaurant": "365 Bank St",
        "rating": "4.6",
        "review_num": "968",
        "cusine_type": ["Chinese", "Bao"],
        "average_cost_per_person": "~\$25 CAD",
        "discount" : "10%",
        "aws_card_match": "Gongfu_Bao"
    },
     {
        "restaurant_name": "Oriental House",
        "address_of_restaurant": "266 Elgin St",
        "rating": "4.1",
        "review_num": "244",
        "cusine_type": ["Chinese"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "Oriental_house"
    },        
]
Structure the response like this:

Based on your request, I suggest:

Restaurant: restaurant_name 🏠
Address: address_of_restaurant 📍
Rating: restaurant_rating ⭐️
Number of Reviews: review_num 🗣️
Average Cost/person: average_cost _per_person 💸
ACAC Discount: discount 🏷️

Always say, is there anything else I can help with at the very end.
''';
