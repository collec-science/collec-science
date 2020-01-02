(function(){
  const CLASSES = {
    BASE: 'autocomplete',
    CONTAINER: 'autocomplete-container',
    INPUT: 'autocomplete__input',
    LABEL: 'autocomplete__label',
    RESULTS: {
      BASE: 'autocomplete__results',
      VISIBLE: 'autocomplete__results--is-visible'
    },
    RESULT: {
      BASE: 'autocomplete__result',
      SELECTED: 'autocomplete__result--is-selected'
    },
    NOTICE: 'autocomplete__notice',
    SELECT_RESULT: 'autocomplete__select-result',
    LIST: 'autocomplete__list'
  };

  const KEY_CODES = {
    ENTER: 13,
    ESC: 27,
    UP: 38,
    DOWN: 40
  }

  class Autocomplete {
    constructor(node) {
      this.select = node;
      this.select.style.display = 'none';
      this.container = this.select.parentElement;
      this.container.classList.add(CLASSES.CONTAINER);
      this.container.style.position = 'relative';
      this.label = this.container.querySelector('label');
      const selectOptions = [].slice.call(node.querySelectorAll('option'));
      const resultsId = `${this.select.id}-autocomplete`;
      this.isVisible = false;
      this.options = selectOptions.map((option, index) => {
        return {
          label: option.textContent,
          value: option.value,
          id: `${this.select.id}-autocomplete-result-${index}`
        };
      });

      this.outputInput(resultsId);
      this.outputResultsList(resultsId);
      this.outputResultsNotice(resultsId);

      window.requestAnimationFrame(() => {
        this.container.appendChild(this.input);
        this.container.appendChild(this.resultsList);
      });

      this.input.addEventListener('input', (evt) => {
        const input = evt.target.value.toLowerCase();
        this.filterResults(input);
      });

      this.input.addEventListener('focus', () => {
        if (this.results) {
          this.showResults();
        } else {
          this.updateResults(this.options);
          this.outputResults();
        }
      });

      this.input.addEventListener('blur', () => {
        this.hideResults();
      });

      document.body.addEventListener('click', (evt) => {
        if (!this.container.contains(evt.target)) {
          this.hideResults();
        }
      });

      document.addEventListener('keydown', (evt) => {
        this.keydownEvent(evt);
      });
    }

    clearSelected() {
      const selected = this.resultsList.querySelector(`.${CLASSES.RESULT.SELECTED}`);
      if (selected) {
        selected.classList.remove(CLASSES.RESULT.SELECTED);
      }
    }

    selectPreviousOption() {
      const selected = this.resultsList.querySelector(`.${CLASSES.RESULT.SELECTED}`);
      if (selected) {
        if (selected === this.resultsList.firstChild) {
          this.selectOption(this.resultsList.lastChild);
        } else {
          this.selectOption(selected.previousSibling);
        }
      }
    }

    selectNextOption() {
      const selected = this.resultsList.querySelector(`.${CLASSES.RESULT.SELECTED}`);
      if (selected) {
        if (selected === this.resultsList.lastChild) {
          this.selectOption(this.resultsList.firstChild);
        } else {
          this.selectOption(selected.nextSibling);
        }
      } else {
        this.selectOption(this.resultsList.firstChild);
      }
    }

    selectOption(optionNode, callback) {
      window.requestAnimationFrame(() => {
        this.clearSelected();
        optionNode.classList.add(CLASSES.RESULT.SELECTED);
        this.input.dataset.selected = optionNode.id;
        optionNode.scrollIntoView(false);
        this.resultsNotice.textContent = optionNode.textContent;
        if (callback) {
          callback();
        }
      });
    }

    chooseOption() {
      const selectedOption = document.getElementById(this.input.dataset.selected);
      this.input.value = selectedOption.textContent;
      this.select.value = selectedOption.dataset.value;
      this.resultsNotice.textContent = `${selectedOption.textContent} selected`;
      this.hideResults();
    }

    clearResults() {
      window.requestAnimationFrame(() => {
        while (this.resultsList.hasChildNodes()) {
          this.resultsList.removeChild(this.resultsList.lastChild);
        }
      });
    }

    filterResults(input) {
      const results = this.options.filter((result) => {
        return (result.value.toLowerCase().indexOf(input) != -1) ||
               (result.label.toLowerCase().indexOf(input) != -1);
      });

      this.updateResults(results);
      this.outputResults();
    }

    hideResults() {
      this.isVisible = false;
      window.requestAnimationFrame(() => {
        this.resultsList.classList.remove(CLASSES.RESULTS.VISIBLE);
        this.input.setAttribute('aria-expanded', 'false');
      });
    }

    updateResults(results) {
      this.clearResults();
      this.results = results;
    }

    outputResults() {
      if (this.results.length > 0) {
        this.results.forEach((result) => {
          const resultListItem = document.createElement('li');
          resultListItem.setAttribute('id', result.id);
          resultListItem.classList.add(CLASSES.RESULT.BASE);
          resultListItem.textContent = result.label;
          resultListItem.dataset.value = result.value;
          resultListItem.setAttribute('role', 'option');
          resultListItem.addEventListener('click', (evt) => {
            this.selectOption(evt.target, () => this.chooseOption());
          });
          window.requestAnimationFrame(() => {
            this.resultsList.appendChild(resultListItem);
          });
        });
      } else {
        const noResultsItem = document.createElement('li');
        noResultsItem.classList.add(CLASSES.RESULT.BASE);
        noResultsItem.textContent = 'No results found';
        window.requestAnimationFrame(() => {
          this.resultsList.appendChild(noResultsItem);
        });
      }
      this.showResults();
    }

    showResults() {
      this.isVisible = true;
      window.requestAnimationFrame(() => {
        this.resultsList.classList.add(CLASSES.RESULTS.VISIBLE);
        this.input.setAttribute('aria-expanded', 'true');
        if (this.results.length === 0) {
          this.resultsNotice.textContent = `No results found`;
        } else if (this.results.length === 1) {
          this.resultsNotice.textContent = '1 result';
        } else {
          this.resultsNotice.textContent = `${this.results.length} results`;
        }
      });
    }

    outputInput(resultsId) {
      this.input = document.createElement('input');
      this.input.type = 'text';
      this.input.setAttribute('role', 'combobox');
      this.input.setAttribute('aria-label', `Search and select an option for ${this.label.textContent}`);
      this.input.setAttribute('aria-expanded', 'false');
      this.input.setAttribute('aria-autocomplete', 'list');
      this.input.setAttribute('aria-owns', resultsId);
      this.input.classList.add(CLASSES.INPUT);

      window.requestAnimationFrame(() => {
        this.container.appendChild(this.input);
      });
    }

    outputResultsList(resultsId) {
      this.resultsList = document.createElement('ul');
      this.resultsList.classList.add(CLASSES.RESULTS.BASE);
      this.resultsList.setAttribute('id', resultsId);
      this.resultsList.setAttribute('role', 'listbox');

      window.requestAnimationFrame(() => {
        this.container.appendChild(this.resultsList);
      });
    }

    outputResultsNotice() {
      this.resultsNotice = document.createElement('div');
      this.resultsNotice.classList.add(CLASSES.NOTICE);
      this.resultsNotice.setAttribute('role', 'status');
      this.resultsNotice.setAttribute('aria-live', 'polite');

      window.requestAnimationFrame(() => {
        this.container.appendChild(this.resultsNotice);
      });
    }

    keydownEvent(evt) {
      if (!this.container.contains(evt.target)) {
        return;
      }
      switch (evt.keyCode) {
        case KEY_CODES.ENTER:
          this.chooseOption();
          break;
        case KEY_CODES.ESC:
          this.hideResults();
          this.input.blur();
          break;
        case KEY_CODES.DOWN:
          if (!this.isVisible) {
            this.showResults();
          } else {
            this.selectNextOption();
          }
          evt.preventDefault();
          break;
        case KEY_CODES.UP:
          evt.preventDefault();
          this.selectPreviousOption();
          break;
      }
    }
  }

  function createAutocomplete(node) {
    return new Autocomplete(node);
  }

  document.addEventListener('DOMContentLoaded', function() {
    const autocompletes = [].slice.call(document.querySelectorAll(`.${CLASSES.BASE}`));
    autocompletes.forEach(createAutocomplete);
  });
})();
