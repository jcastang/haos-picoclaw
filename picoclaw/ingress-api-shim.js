/* NGINX-served compatibility layer for the upstream Launcher absolute API URLs.
 * Runs before Vite's module scripts; upstream PicoClaw remains untouched. */
(() => {
  const originalFetch = window.fetch.bind(window);
  function ingressRoot() {
    const match = window.location.pathname.match(/^(.*\/api\/hassio_ingress\/[^/]+\/)/);
    if (match) return match[1];
    const base = document.querySelector('base[href]');
    if (base) {
      try { return new URL(base.getAttribute('href'), location.href).pathname; }
      catch (_) {}
    }
    return location.pathname.replace(/[^/]*$/, '');
  }
  function rewrite(value) {
    const url = typeof value === 'string' ? value : value instanceof URL ? value.href : null;
    if (url === null) return value;
    if (url.startsWith('/api/')) return ingressRoot() + url.slice(1);
    if (url.startsWith(location.origin + '/api/')) return location.origin + ingressRoot() + url.slice((location.origin + '/').length);
    return value;
  }
  window.fetch = function(input, init) {
    if (input instanceof Request) {
      const updated = rewrite(input.url);
      if (updated !== input.url) input = new Request(updated, input);
    } else {
      input = rewrite(input);
    }
    return originalFetch(input, init);
  };
})();
