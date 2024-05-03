Cypress.Commands.add('siginUser', ({ email, password }) => {
    cy.session(
      [email, password],
      () => {
        cy.visit('/users/sign_in');
        cy.get('input[name="user[email]"]').type(email);
        cy.get('input[name="user[password]"]').type(`${password}{enter}`);
      },
      {
        cacheAcrossSpecs: true,
      },
    );
});