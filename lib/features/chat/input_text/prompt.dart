String jsonText = '''

Hey Gemini! Pretend you were a food critic, from the following list of restaurants, recommend me a restaurant:
Do not mention aws_card_match, that is not relevant data for user, do not 
forget to mention the link as well
[
    {
        "restaurant_name": "Pho lady",
        "address_of_restaurant": "280 Elgin St,",
        "rating": "4.6",
        "review_num": "66",
        "cuisine_type": ["Vietnamese", "Pho", "Noodle"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "Pho_Lady"
    },
    {
        "restaurant_name": "Dakogi Elgin",
        "address_of_restaurant": "280 Elgin St",
        "rating": "3.9",
        "review_num": "720",
        "cuisine_type": ["Korean", "Fried Chicken"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "Dakogi_Elgin"
    },
    {
        "restaurant_name": "La Noodle",
        "address_of_restaurant": "1383 Clyde Ave",
        "rating": "3.2",
        "review_num": "132",
        "cuisine_type": ["Chinese", "Noodle"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "La_Noodle"
    },
    {
        "restaurant_name": "Chatime",
        "address_of_restaurant": "695 Somerset St",
        "rating": "4.4",
        "review_num": "123",
        "cuisine_type": ["Bubble Tea", "Desert"],
        "average_cost_per_person": "~\$10 CAD",
        "discount" : "10%",
        "aws_card_match": "Chatime"
    },
    {
        "restaurant_name": "Dakogi Marketplace",
        "address_of_restaurant": "80 Marketplace Ave",
        "rating": "4.1",
        "review_num": "104",
        "cuisine_type": ["Korean", "Fried Chicken"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "Dakogi_Marketplace"
    },
    {
        "restaurant_name": "Friends&KTV",
        "address_of_restaurant": "1430 Prince of Wales",
        "rating": "3.7",
        "review_num": "73",
        "cuisine_type": ["Chinese"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "Friends&KTV"
    },
    {
        "restaurant_name": "Pomelo Hat",
        "address_of_restaurant": "1196 Bank St",
        "rating": "4.7",
        "review_num": "197",
        "cuisine_type": ["Bubble Tea"],
        "average_cost_per_person": "~\$10 CAD",
        "discount" : "10%",
        "aws_card_match": "Pomelo_Hat"
    },
    {
        "restaurant_name": "Fuwa Fuwa",
        "address_of_restaurant": "1200 St. Laurent Blvd",
        "rating": "3.9",
        "review_num": "83",
        "cuisine_type": ["Desert", "Pancakes"],
        "average_cost_per_person": "~\$20 CAD",
        "discount" : "10%",
        "aws_card_match": "Fuwa_Fuwa"
    },
    {
        "restaurant_name": "Shuyi Tealicious",
        "address_of_restaurant": "1400 Clyde Ave",
        "rating": "4.3",
        "review_num": "61",
        "cuisine_type": ["Bubble Tea", "Drinks"],
        "average_cost_per_person": "~\$10 CAD",
        "discount" : "10%",
        "aws_card_match": "Shuyi_Tealicious"
    },
    {
        "restaurant_name": "Gongfu Bao",
        "address_of_restaurant": "365 Bank St",
        "rating": "4.6",
        "review_num": "968",
        "cuisine_type": ["Chinese", "Bao"],
        "average_cost_per_person": "~\$25 CAD",
        "discount" : "10%",
        "aws_card_match": "Gongfu_Bao"
    },
    {
        "restaurant_name": "Hot Star Chicken",
        "address_of_restaurant": "412 Dalhousie St",
        "rating": "4.1",
        "review_num": "109",
        "cuisine_type": ["Korean", "Fried Chicken"],
        "average_cost_per_person": "~\$15 CAD",
        "discount" : "10%",
        "aws_card_match": "Hot_Star_Chicken"
    },
    {
        "restaurant_name": "Kinton Ramen",
        "address_of_restaurant": "216 Elgin St #2",
        "rating": "4.8",
        "review_num": "1569",
        "cuisine_type": ["Japanese", "Noodle"],
        "average_cost_per_person": "~\$25 CAD",
        "discount" : "10%",
        "aws_card_match": "kinton_ramen"
    },
     {
        "restaurant_name": "Oriental House",
        "address_of_restaurant": "266 Elgin St",
        "rating": "4.1",
        "review_num": "244",
        "cuisine_type": ["Chinese"],
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
