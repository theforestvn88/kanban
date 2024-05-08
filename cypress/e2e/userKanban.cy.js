describe("user Kanban", () => {
    beforeEach(() => {
        cy.then(Cypress.session.clearCurrentSessionData)
        cy.fixture('users/user1.json').as('user');
        cy.get('@user').then((user) => {
            cy.signinUser(user);
        });

        cy.fixture('boards/user1_boards.json').as('boards');
        // cy.fixture('boards/user1_boards.json').as('boards');
        // cy.fixture('boards/user1_boards.json').as('boards');
    });

    it("show kanban menu", () => {
        cy.visit("/")
        cy.get('h1').should('contain', 'Kanban');
        cy.get('a').should('have.attr', 'href').and('contain', '/boards');
    });

    it("show user boards", () => {
        cy.visit("/");
        cy.get('a[href="/boards"]').click();
        cy.get('@boards').then((boards) => {
            for(const board of boards) {
                cy.get('a').should('contain', board.name);
            }
        })
    });

    it("show user current board", () => {
        cy.visit("/");
        cy.get('a[href="/boards"]').click();
        cy.get('a').contains('board1').click();
        cy.get('@boards').then((boards) => {
            const board1 = boards[0];
            for(const list of board1.lists) {
                cy.get('span').should('contain', list.name);
            }

            const list1 = board1.lists[0];
            cy.get(`div[id="list_${list1.id}"]`).within(() => {
                for(const card of list1.cards) {
                    cy.get('a').should('contain', card.title);
                }
            });
        })
    });
});
