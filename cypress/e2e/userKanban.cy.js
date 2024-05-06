describe("user Kanban", () => {
    beforeEach(() => {
        cy.fixture('users/user1.json').as('user');
        cy.get('@user').then((user) => {
            cy.signinUser(user)
        });

        cy.fixture('boards/user1_boards.json').as('boards');
    });

    it("show user boards", () => {
        cy.visit("/")
        cy.get('@boards').then((boards) => {
            for(const board of boards) {
                cy.get('a').should('contain', board.name)
            }
        })
    });
});
