/**
 * Envio do formulário de contato via FormSubmit, sem sair da página.
 *
 * O envio nativo (POST + redirect via _next) tirava o visitante do site e
 * nunca mostrava a div .sent-message que já existe na marcação. Aqui usamos
 * o endpoint /ajax/ do FormSubmit, que responde JSON, e damos o retorno na
 * própria página.
 *
 * Não usar o validate.js do template: ele espera a resposta literal "OK" de
 * um backend PHP da BootstrapMade e sempre cairia no erro com o FormSubmit.
 */
(function () {
  "use strict";

  var form = document.querySelector('.php-email-form');
  if (!form) return;

  var loading = form.querySelector('.loading');
  var erro = form.querySelector('.error-message');
  var enviado = form.querySelector('.sent-message');

  function mostrarErro(texto) {
    loading.classList.remove('d-block');
    erro.textContent = texto;
    erro.classList.add('d-block');
  }

  form.addEventListener('submit', function (event) {
    event.preventDefault();

    loading.classList.add('d-block');
    erro.classList.remove('d-block');
    enviado.classList.remove('d-block');

    // FormData mantém o content-type multipart, que é CORS-safelisted e não
    // dispara preflight. Um header como X-Requested-With dispararia, e o
    // FormSubmit não responde ao OPTIONS.
    fetch(form.getAttribute('action'), {
      method: 'POST',
      body: new FormData(form),
      headers: { 'Accept': 'application/json' }
    })
      .then(function (resposta) {
        return resposta.json().catch(function () {
          throw new Error('Resposta inesperada do servidor de e-mail.');
        });
      })
      .then(function (dados) {
        if (String(dados.success) === 'true') {
          loading.classList.remove('d-block');
          enviado.classList.add('d-block');
          form.reset();
        } else {
          mostrarErro(dados.message || 'Não foi possível enviar. Tente novamente.');
        }
      })
      .catch(function (e) {
        mostrarErro(e.message || 'Falha de conexão. Verifique sua internet e tente novamente.');
      });
  });
})();
