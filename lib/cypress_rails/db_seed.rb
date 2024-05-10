# users
user1 = User.create!(email: "user_1@example.com", password: "123456", password_confirmation: "123456")

# boards
board1 = Board.create!(id: 1, name: "board1", user: user1)
board2 = Board.create!(id: 2, name: "board2", user: user1)

# lists
list1 = List.create!(id: 1, name: "list1", board: board1, user: user1)
list2 = List.create!(id: 2, name: "list2", board: board1, user: user1)

# cards
card1 = Card.create!(id: 1, title: "card1", list: list1, board: board1, user: user1)
card2 = Card.create!(id: 2, title: "card2", list: list1, board: board1, user: user1)
card3 = Card.create!(id: 3, title: "card3", list: list1, board: board1, user: user1)
card4 = Card.create!(id: 4, title: "card4", list: list1, board: board1, user: user1)

card5 = Card.create!(id: 5, title: "card5", list: list2, board: board1, user: user1)
