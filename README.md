<p align="center">
  <a href="https://pushizo.com"><img src="https://raw.githubusercontent.com/pushizo/.github/main/profile/assets/mark.svg" alt="Pushizo" width="56" height="56"></a>
</p>

<h1 align="center">Pushizo Web Push — Google Tag Manager template</h1>

<p align="center"><a href="#english">English</a> · <a href="#türkçe">Türkçe</a></p>

## English

A Google Tag Manager (web) tag template that loads the Pushizo Web SDK, initializes web push for your app and sends
custom events, tags or the logged-in user's external ID — no code changes on your site.

1. In GTM: **Templates → Tag Templates → Search Gallery → "Pushizo Web Push"** (or **New → Import** `template.tpl`).
2. Create a **Pushizo Web Push** tag and enter your **App ID** (and **API URL** for a self-hosted or regional API).
3. Actions:
   - **Initialize** — fire on *Initialization – All Pages*.
   - **Send event** — name, optional numeric value, properties.
   - **Add tags** — key/value pairs.
   - **Log in (external ID)** — link the visitor to your own user id.
   Every action loads the SDK and initializes it idempotently first.
4. Serve the service worker (`PushizoSDKWorker.js`) from your site root, or set **Service worker path** in the tag.

Permissions are limited to `inject_script` (`https://api.pushizo.com/sdk-web/*`), `access_globals` (the `Pushizo`
object) and `logging`. Documentation: [docs.pushizo.com/docs/integrations](https://docs.pushizo.com/docs/integrations).

## Türkçe

Pushizo Web SDK'sını yükleyen, uygulamanız için web push'u başlatan ve özel olay, tag ya da oturum açan kullanıcının
dış kimliğini gönderen Google Tag Manager (web) etiket şablonu — sitenizde kod değişikliği gerekmez.

1. GTM'de **Şablonlar → Etiket şablonları → Galeride ara → "Pushizo Web Push"** (ya da **Yeni → İçe aktar** ile
   `template.tpl`).
2. **Pushizo Web Push** türünde etiket oluşturun; **App ID**'yi girin (kendi ya da bölgesel API'niz için **API URL**).
3. Eylemler:
   - **Initialize** — *Initialization – All Pages* tetikleyicisiyle.
   - **Send event** — ad, isteğe bağlı sayısal değer, özellikler.
   - **Add tags** — anahtar/değer.
   - **Log in (external ID)** — ziyaretçiyi kendi kullanıcı kimliğinizle eşler.
   Her eylem önce SDK'yı yükler ve idempotent olarak başlatır.
4. Service worker dosyasını (`PushizoSDKWorker.js`) sitenizin kökünden sunun ya da etikette **Service worker path**
   alanını doldurun.

İzinler `inject_script` (`https://api.pushizo.com/sdk-web/*`), `access_globals` (`Pushizo` nesnesi) ve `logging` ile
sınırlıdır. Belgeler: [docs.pushizo.com/docs/integrations](https://docs.pushizo.com/docs/integrations).

---

Bugs · Hata bildirimi: [Issues](https://github.com/pushizo/pushizo-gtm-template/issues) · Security · Güvenlik:
[security@pushizo.com](mailto:security@pushizo.com). This repository is generated from the Pushizo main repository ·
Bu depo Pushizo ana deposundan üretilir. Template licensed under Apache 2.0 · Şablon Apache 2.0 lisanslıdır ([LICENSE](LICENSE)).
