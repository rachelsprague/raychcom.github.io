---
layout: default
title: Raych
body_class: home-page
---

<div class="landing-container">

  <!-- Logo / Icon -->
  <img src="/assets/images/raych.png" alt="raych logo" class="logo">

  <!-- Social media icons inline -->
<div class="social-icons-inline">
  <a href="https://open.spotify.com/user/31ekhjd5x5qoyln7zo4zkv4tneay" target="_blank" rel="noopener" aria-label="Spotify">
    <i class="fa-brands fa-spotify"></i>
  </a>
  <a href="https://last.fm/user/raych__" target="_blank" rel="noopener" aria-label="Last.fm">
    <i class="fa-brands fa-lastfm"></i>
  </a>
  <a href="https://bsky.app/profile/raych.com" target="_blank" rel="noopener" aria-label="Bluesky">
    <img src="/assets/icons/bluesky.svg" alt="Bluesky" class="social-svg">
  </a>
  <a href="https://youtube.com/@raych_com" target="_blank" rel="noopener" aria-label="YouTube">
    <i class="fa-brands fa-youtube"></i>
  </a>
  <a href="https://www.twitch.tv/raych_com" target="_blank" rel="noopener" aria-label="Twitch">
    <i class="fa-brands fa-twitch"></i>
  </a>
  <a href="https://byraych.substack.com/" target="_blank" rel="noopener" aria-label="Substack">
    <i class="fa-solid fa-newspaper"></i>
  </a>
</div>

<!-- NOW -->
<h2>Now</h2>

<div class="now-container">
  <div class="now-item" id="twitch-status">
    🐢 Checking aquarium stream…
  </div>

  <div class="now-item" id="music">
    <img id="album-art" src="" alt="" />
    <div>
      <span id="track-status">Loading music…</span><br>
      <span id="track-name"></span>
    </div>
  </div>
</div>


  <!-- Links Section -->
  <h2>Links</h2>
  <a href="https://open.spotify.com/playlist/4PqkabW4RTD3BxMaKsye3L" target="_blank" rel="noopener">Jams of the Week</a>
  <a href="https://bsky.app/profile/photos.raych.com" target="_blank" rel="noopener">Photos (Bluesky)</a>
  <a href="https://bsky.app/profile/shorts.raych.com" target="_blank" rel="noopener">Shorts (Bluesky)</a>
  <a href="https://turtles.raych.com" target="_blank" rel="noopener">🐢 Turtles 🐢</a>
  <a href="https://www.twitch.tv/raych_com" target="_blank" rel="noopener">🐠 Aquarium Livestream 🐠</a>
  <a href="/makes/" target="_blank" rel="noopener">Raych Makes</a>

  <!-- Utilities Section 
  <h2>Utilities</h2>
  <a href="https://datasetsearch.research.google.com/" target="_blank">Google Dataset Search</a>
  <a href="https://www.kaggle.com/datasets" target="_blank">Kaggle Datasets</a> -->

</div>

<script>

/* ================================
   LAST.FM NOW PLAYING
   ================================ */

const LASTFM_API_KEY = "362257f700e984e696cf0179e578e4f6";
const LASTFM_USER = "raych__";

async function updateNowPlaying() {

  try {

    const url =
      `https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks` +
      `&user=${LASTFM_USER}&api_key=${LASTFM_API_KEY}&format=json&limit=1`;

    const res = await fetch(url);
    const data = await res.json();

    const track = data?.recenttracks?.track?.[0];

    if (!track) return;

    const artist = track.artist["#text"];
    const title = track.name;
    const art = track.image?.[2]?.["#text"] || "";

    const isNowPlaying = track["@attr"]?.nowplaying === "true";

    const statusText = isNowPlaying
      ? "🎧 Now playing:"
      : "🎧 Last played:";

    const trackText = `${artist} — ${title}`;

    const musicBox = document.getElementById("music");

    musicBox.style.opacity = 0;

    setTimeout(() => {

      document.getElementById("track-status").textContent = statusText;
      document.getElementById("track-name").textContent = trackText;

      if (art) {
        document.getElementById("album-art").src = art;
      }

      musicBox.style.opacity = 1;

    }, 300);

  }

  catch {

    document.getElementById("track-status").textContent = "🎧 Music unavailable";

  }

}

/* ================================
   TWITCH STATUS
   ================================ */

async function updateTwitchStatus() {

  try {

    const res = await fetch("https://decapi.me/twitch/uptime/raych_com");
    const text = await res.text();

    const el = document.getElementById("twitch-status");

    if (text.includes("offline")) {

      el.textContent = "🐢 Aquarium stream offline";

    } else {

      el.innerHTML = `🐢 Live on Twitch (${text})`;

    }

  }

  catch {

    document.getElementById("twitch-status").textContent =
      "🐢 Stream status unavailable";

  }

}

updateNowPlaying();
updateTwitchStatus();

setInterval(updateNowPlaying, 60000);
setInterval(updateTwitchStatus, 60000);

</script>


<!-- Hub text 
  <div class="home-hub__text">
<p>Domain names are like $15/year 🤷🏻‍♀️, so here we are.</p>
<p>Weekly music picks. Personal projects. Stuff. </p>
<p>I’m a tech-y gal who listens to too much music and mostly hangs with my <s>fiancée</s> wife and pets. </p>
</div> -->
