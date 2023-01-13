export function resetOptions(target, text, disable = true) {
  let Option = `<option value="0">${text}</option>`;

  target.replaceChildren();
  target.insertAdjacentHTML("beforeend", Option);
  target.disabled = disable;
}
