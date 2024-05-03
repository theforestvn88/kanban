describe("user Kanban", () => {
    beforeEach(() => {
        cy.fixture('users/user1').as('user')
        cy.get('@user').then((user) => {
            cy.loginUser(user)
        });
    });

    it("show user boards", () => {
        cy.get('h1').should('contain', 'Kanban')
    });
});
