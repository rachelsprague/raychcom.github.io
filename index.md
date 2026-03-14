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

  <!-- NOW Section -->
  <h2>Now</h2>
  <div class="now-container">
    <!-- Twitch status -->
    <a href="https://www.twitch.tv/raych_com" target="_blank" rel="noopener" class="now-item-link">
    <div class="now-item" id="twitch-status">
      🐠 🐢 Checking aquarium stream…
    </div>
    </a>

    <!-- Last.fm now playing -->
    <a href="https://www.last.fm/user/raych__" target="_blank" rel="noopener" class="now-item-link">
    <div class="now-item" id="music">
      <img id="album-art" src="" alt="Album art" />
      <div>
        <span id="track-status">Loading music…</span><br>
        <span id="track-name"></span>
        <div id="track-timestamp" style="font-size:0.8rem; opacity:0.7;"></div>
      </div>
    </div>
  </div>
  </a>

  <!-- Links Section -->
  <h2>Links</h2>
  <a href="https://open.spotify.com/playlist/4PqkabW4RTD3BxMaKsye3L" target="_blank" rel="noopener">Jams of the Week</a>
  <a href="https://bsky.app/profile/photos.raych.com" target="_blank" rel="noopener">Photos (Bluesky)</a>
  <a href="https://bsky.app/profile/shorts.raych.com" target="_blank" rel="noopener">Shorts (Bluesky)</a>
  <a href="https://turtles.raych.com" target="_blank" rel="noopener">🐢 Turtles 🐢</a>
  <a href="https://www.twitch.tv/raych_com" target="_blank" rel="noopener">🐠 Aquarium Livestream 🐠</a>
  <a href="/makes/" target="_blank" rel="noopener">Raych Makes</a>

</div>

<!-- ================================
     JS for Last.fm + Twitch Now Playing
=============================== -->
<script>
const LASTFM_API_KEY = "362257f700e984e696cf0179e578e4f6";
const LASTFM_USER = "raych__";
const REFRESH_MS = 60000;

// ------------------------
// Last.fm Now Playing
// ------------------------
async function updateNowPlaying() {
  try {
    const url = `https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${LASTFM_USER}&api_key=${LASTFM_API_KEY}&format=json&limit=1`;
    const res = await fetch(url);
    const data = await res.json();
    const track = data?.recenttracks?.track?.[0];
    if (!track) return;

    const artist = track.artist["#text"];
    const title = track.name;
    const art = track.image?.[2]?.["#text"] || "";
    const isNowPlaying = track["@attr"]?.nowplaying === "true";

    const statusText = isNowPlaying ? "🎧 Now playing:" : "🎧 Last played:";
    const trackText = `${artist} — ${title}`;

    // timestamp if not currently playing
    let timestampText = "";
    if (!isNowPlaying && track.date?.uts) {
      const playedTime = new Date(track.date.uts * 1000);
      const now = new Date();
      const diffMinutes = Math.floor((now - playedTime) / 60000);
      if (diffMinutes < 60) timestampText = `scrobbled ${diffMinutes} min ago`;
      else timestampText = `scrobbled ${Math.floor(diffMinutes/60)} hr ago`;
    }

    const musicBox = document.getElementById("music");

    // fade out + slide down
    musicBox.style.opacity = 0;
    musicBox.style.transform = "translateY(4px)";

    setTimeout(() => {
      document.getElementById("track-status").textContent = statusText;
      document.getElementById("track-name").textContent = trackText;

      const albumArtEl = document.getElementById("album-art");
      albumArtEl.src = art;

      // wrap album art in Last.fm track link
      if (track.url) {
        if (!albumArtEl.parentElement.href) {
          const link = document.createElement("a");
          link.href = track.url;
          link.target = "_blank";
          link.rel = "noopener";
          albumArtEl.replaceWith(link);
          link.appendChild(albumArtEl);
        } else {
          albumArtEl.parentElement.href = track.url;
        }
      }

      // timestamp
      let tsEl = document.getElementById("track-timestamp");
      tsEl.textContent = timestampText;

      // fade in + slide up
      musicBox.style.opacity = 1;
      musicBox.style.transform = "translateY(0)";
    }, 300);

  } catch {
    document.getElementById("track-status").textContent = "🎧 Music unavailable";
    document.getElementById("track-name").textContent = "";
  }
}

updateNowPlaying();
setInterval(updateNowPlaying, REFRESH_MS);

// ------------------------
// Twitch Stream Status
// ------------------------
async function updateTwitchStatus() {
  try {
    const res = await fetch("https://decapi.me/twitch/uptime/raych_com");
    const text = await res.text();

    const el = document.getElementById("twitch-status");
    el.style.opacity = 0;
    el.style.transform = "translateY(4px)";

    setTimeout(() => {
      if (text.includes("offline")) {
        el.textContent = "🐠 🐢 Aquarium stream offline";
        el.classList.remove("live", "animate");
      } else {
        el.textContent = `🐠 🐢 Live on Twitch (${text})`;
        el.classList.add("live", "animate");
      }
      el.style.opacity = 1;
      el.style.transform = "translateY(0)";
    }, 300);

  } catch {
    const el = document.getElementById("twitch-status");
    el.textContent = "🐠 Stream status unavailable";
  }
}

updateTwitchStatus();
setInterval(updateTwitchStatus, 60000);
</script>