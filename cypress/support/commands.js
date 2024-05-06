Cypress.Commands.add('signupUser', ({ email, password }) => {
    cy.session(
      [email, password],
      () => {
        cy.visit('/users/sign_up');
        cy.get('input[name="user[email]"]').type(email);
        cy.get('input[name="user[password]"]').type(password);
        cy.get('input[name="user[password_confirmation]"]').type(`${password}{enter}`);
      },
      {
        cacheAcrossSpecs: true,
      },
    );
});

Cypress.Commands.add('signinUser', ({ email, password }) => {
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
