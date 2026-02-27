<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{ page.title }} | {{ site.title }}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/assets/css/style.css">
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
</body>
</html>
