import { Application } from '@hotwired/stimulus';

// Initializes and registers the controller for the test file
// Use it in a before block:
// beforeEach(() => startStimulus('dom', DomController));
//
// @name = string of the controller
// @controller = controller class
//
// https://stimulus.hotwired.dev/handbook/installing#using-other-build-systems
export function startStimulus(name, controller) {
  const application = Application.start();
  application.register(name, controller);
}

// Helper function for setting HTML
// - It trims content to prevent false negatives
// - It's async so there's time for the Stimulus controller to load
//
// Use within tests:
// await setHTML(`<p>My HTML Content</p>`);
export async function setHTML(content = '') {
  document.body.innerHTML = content.trim();
  return document.body.innerHTML;
}

// Helper function for getting HTML content
// - Trims content to prevent false negatives
// - Is consistent with setHTML
//
// Use within tests:
// expect(getHTML()).toEqual('something');
export function getHTML() {
  return document.body.innerHTML.trim();
}