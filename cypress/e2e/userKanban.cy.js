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
                cy.get('div').should('contain', list.name);
            }

            const list1 = board1.lists[0];
            cy.get(`div[id="list_${list1.id}"]`).within(() => {
                for(const card of list1.cards) {
                    cy.get('a').should('contain', card.title);
                }
            });

            const list2 = board1.lists[1];
            cy.get(`div[id="list_${list2.id}"]`).within(() => {
                for(const card of list2.cards) {
                    cy.get('a').should('contain', card.title);
                }
            });
        })
    });

    it("do some `actions` with list", () => {
        cy.visit("/");
        cy.get('a[href="/boards"]').click();
        cy.get('a').contains('board1').click();

        cy.get('div[id="list_1"] button[data-action="click->popup#toggle"]').click();
        cy.get('turbo-frame[id="partial_content"] div div a').should('have.attr', 'href').and('contain', '/lists/1/edit');
        cy.get('turbo-frame[id="partial_content"] div div a').eq(1).should('have.attr', 'data-turbo-method').and('contain', 'delete');
    })

    it("drag & drop cards", () => {
        cy.visit("/");
        cy.get('a[href="/boards"]').click();
        cy.get('a').contains('board1').click();

        const dataTransfer = new DataTransfer();

        cy.get(`a[id="card_1"]`).trigger('pointerdown', {
            which: 1,
            button: 0,
            eventConstructor: 'PointerEvent',
            force: true
        })
        .trigger('mousedown', {
            which: 1,
            button: 0,
            eventConstructor: 'MouseEvent',
            force: true
        })
        .trigger('dragstart', { 
            dataTransfer, 
            force: true, 
            eventConstructor: 'DragEvent' 
        });

        cy.get(`a[id="card_5"]`).trigger('dragover', {
            dataTransfer,
            eventConstructor: 'DragEvent',
            force: true
        })
        .trigger('drop', {
            dataTransfer,
            eventConstructor: 'DragEvent',
            force: true
        });
        
        cy.get('@boards').then((boards) => {
            const board1 = boards[0];
            const list2 = board1.lists[1];
            cy.get(`div[id="list_${list2.id}"]`).within(() => {
                cy.get('a').should('contain', "card1");
            });
        });
    })
});
