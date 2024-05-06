# users
user1 = User.create!(email: "user_1@example.com", password: "123456", password_confirmation: "123456")

# boards
board1 = Board.create!(name: "board1", user: user1)
board2 = Board.create!(name: "board2", user: user1)
