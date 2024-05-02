import { screen } from '@testing-library/dom';
import { getHTML, setHTML, startStimulus } from './stimulus_helper';
import ModalController from '@javascripts/controllers/modal_controller';
import * as elTransition from "el-transition"

beforeEach(() => startStimulus('modal', ModalController));

test('close modal', async () => {
    jest.spyOn(elTransition, "leave")
    elTransition.leave.mockImplementation((el) => {
        return Promise.resolve(1);
    })

    await setHTML(`
        <div data-controller="modal"         
        data-transition-enter="transition ease-out duration-100"
        data-transition-enter-start="transform opacity-0 scale-95"
        data-transition-enter-end="transform opacity-100 scale-100"
        data-transition-leave="transition ease-in duration-75"
        data-transition-leave-start="transform opacity-100 scale-100"
        data-transition-leave-end="transform opacity-0 scale-95">
            <button data-action="click->modal#close">close</button>
        </div>
    `);

    const button = screen.getByText('close');
    await button.click();
  
    expect(getHTML()).toEqual('');
});