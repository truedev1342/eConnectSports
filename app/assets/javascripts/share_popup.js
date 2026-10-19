// Opens social share links in a popup window.
//
// Replaces the inline onClick="window.open(...)" handlers these links used to
// carry. Inline handlers cannot be allowed by a CSP nonce, so they were the one
// thing preventing the policy from being enforced rather than report-only.
(function () {
  function openPopup(event) {
    var link = event.target.closest ? event.target.closest('.js-share-popup') : null;
    if (!link) { return; }

    var url = link.getAttribute('data-share-url');
    if (!url) { return; }

    event.preventDefault();
    window.open(url, 'socialshare', 'width=600,height=400');
  }

  document.addEventListener('click', openPopup);
})();
