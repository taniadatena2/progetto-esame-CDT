$(document).ready(function () {
  let currentFacsimile = 0;
  let currentText = 0;

  const $facsimilePages = $('#facsimilePages .page');
  const $textPages = $('#textPages .page');

  function showPage($pages, index) {
    $pages.hide().eq(index).show();
  }

  function updateNavButtons(prefix, index, total) {
    $(`#prevPage${prefix}`).prop('disabled', index === 0);
    $(`#nextPage${prefix}`).prop('disabled', index === total - 1);
  }

  function initPages() {
    showPage($facsimilePages, currentFacsimile);
    updateNavButtons('Facsimile', currentFacsimile, $facsimilePages.length);

    showPage($textPages, currentText);
    updateNavButtons('Text', currentText, $textPages.length);

    $('#textPages').hide(); // di default mostra solo le immagini
  }

  initPages();

  // Bottoni immagini (facsimile)
  $('#nextPageFacsimile').click(function () {
    if (currentFacsimile < $facsimilePages.length - 1) {
      currentFacsimile++;
      showPage($facsimilePages, currentFacsimile);
      updateNavButtons('Facsimile', currentFacsimile, $facsimilePages.length);
    }
  });

  $('#prevPageFacsimile').click(function () {
    if (currentFacsimile > 0) {
      currentFacsimile--;
      showPage($facsimilePages, currentFacsimile);
      updateNavButtons('Facsimile', currentFacsimile, $facsimilePages.length);
    }
  });

  // Bottoni testo (edizione digitale)
  $('#nextPageText').click(function () {
    if (currentText < $textPages.length - 1) {
      currentText++;
      showPage($textPages, currentText);
      updateNavButtons('Text', currentText, $textPages.length);
    }
  });

  $('#prevPageText').click(function () {
    if (currentText > 0) {
      currentText--;
      showPage($textPages, currentText);
      updateNavButtons('Text', currentText, $textPages.length);
    }
  });

  // Bottone che alterna edizione digitale / rivista
  $('#btnEdition').click(function () {
    const isShowingFacsimile = $('#facsimilePages').is(':visible');

    if (isShowingFacsimile) {
      $('#facsimilePages').hide();
      $('#textPages').show();
      $(this).text('Rivista');
    } else {
      $('#textPages').hide();
      $('#facsimilePages').show();
      $(this).text('Edizione Digitale');
    }
  });
});
