<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{ page.title }} | {{ site.title }}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/assets/css/style.css">

  <!-- Google tag (gtag.js) -->
  {% if jekyll.environment == "production" %}
  <script async src="https://www.googletagmanager.com/gtag/js?id=G-JTQC9ZT68S"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());

    gtag('config', 'G-JTQC9ZT68S');
  </script>
  {% endif %}

</head>
<body>
  <main>
    <article>
      <h1>{{ page.title }}</h1>
      <p><em>{{ page.date | date: "%B %-d, %Y" }}</em></p>
      {{ content }}
    </article>

    <hr>
    <p><a href="/">Back to Home</a></p>
  </main>

  <footer style="text-align:center; font-size:0.9rem; color:#555; margin-top:3rem;">
    &copy; {{ "now" | date: "%Y" }} {% if site.title %}{{ site.title }}{% else %}Raych{% endif %} · 
    <a href="/privacy" style="color:#555; text-decoration:underline;">Privacy Policy</a>
  </footer>
  
</body>
</html>
