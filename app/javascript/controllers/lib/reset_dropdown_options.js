export function resetOptions(target, text) {
  let Option = `<option value="0">${text}</option>`;

  target.replaceChildren();
  target.insertAdjacentHTML("beforeend", Option);
  target.disabled = true;
}
