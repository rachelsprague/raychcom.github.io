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
      <span id="track-status">Loading music…</span>
      <img id="album-art" src="" alt="Album art" />
      <div>
        <span id="track-name"></span>
        <div id="track-timestamp" style="font-size:0.8rem; opacity:0.7;"></div>
      </div>
    </div>
    </a>
  </div>

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
     Unified JS for Last.fm + Twitch Now Playing
=============================== -->
<script>
const LASTFM_API_KEY = "362257f700e984e696cf0179e578e4f6";
const LASTFM_USER = "raych__";
const REFRESH_MS = 60000; // refresh every 60s

// ------------------------
// Helper: smooth fade + slide update
// ------------------------
function animateBoxUpdate(box, callback) {
  box.style.opacity = 0;
  box.style.transform = "translateY(4px)";
  setTimeout(() => {
    callback();
    box.style.opacity = 1;
    box.style.transform = "translateY(0)";
  }, 300);
}

// ------------------------
// Last.fm Now Playing
// ------------------------
async function updateNowPlaying() {
  try {
    const recentUrl = `https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${LASTFM_USER}&api_key=${LASTFM_API_KEY}&format=json&limit=1`;
    const res = await fetch(recentUrl);
    const data = await res.json();
    const track = data?.recenttracks?.track?.[0];
    if (!track) return;

    const artist = track.artist["#text"];
    const title = track.name;
    const art = track.image?.[2]?.["#text"] || "";
    const isNowPlaying = track["@attr"]?.nowplaying === "true";

    const statusText = isNowPlaying ? "🎧 Now playing:" : "🎧 Last played:";
    const trackText = `${artist} — ${title}`;

    // Timestamp if not playing
    let timestampText = "";
    if (!isNowPlaying && track.date?.uts) {
      const playedTime = new Date(track.date.uts * 1000);
      const now = new Date();
      const diffMinutes = Math.floor((now - playedTime) / 60000);
      timestampText = diffMinutes < 60
        ? `scrobbled ${diffMinutes} min ago`
        : `scrobbled ${Math.floor(diffMinutes/60)} hr ago`;
    }

    const musicBox = document.getElementById("music");
    if (isNowPlaying) musicBox.classList.add("playing");
    else musicBox.classList.remove("playing");

    animateBoxUpdate(musicBox, async () => {
      document.getElementById("track-status").textContent = statusText;
      document.getElementById("track-name").textContent = trackText;

      // Album art clickable
      const albumArtEl = document.getElementById("album-art");
      albumArtEl.src = art;
      albumArtEl.onclick = () => {
        const trackUrl = `https://www.last.fm/user/${LASTFM_USER}/library/tracks`;
        window.open(trackUrl, "_blank");
      };

      // Play count via track.getInfo
      const trackInfoUrl = `https://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=${LASTFM_API_KEY}&artist=${encodeURIComponent(artist)}&track=${encodeURIComponent(title)}&user=${LASTFM_USER}&format=json`;
      try {
        const infoRes = await fetch(trackInfoUrl);
        const infoData = await infoRes.json();
        const userPlayCount = infoData?.track?.userplaycount || 1;

        let playCountEl = document.getElementById("track-playcount");
        if (!playCountEl) {
          playCountEl = document.createElement("div");
          playCountEl.id = "track-playcount";
          playCountEl.style.fontSize = "0.8rem";
          playCountEl.style.opacity = "0.7";
          musicBox.appendChild(playCountEl);
        }
        playCountEl.textContent = `${userPlayCount} plays`;
      } catch {
        let playCountEl = document.getElementById("track-playcount");
        if (playCountEl) playCountEl.textContent = "";
      }

      // Timestamp
      if (timestampText) {
        let tsEl = document.getElementById("track-timestamp");
        if (!tsEl) {
          tsEl = document.createElement("div");
          tsEl.id = "track-timestamp";
          tsEl.style.fontSize = "0.8rem";
          tsEl.style.opacity = "0.7";
          musicBox.appendChild(tsEl);
        }
        tsEl.textContent = timestampText;
      }
    });

  } catch {
    const musicBox = document.getElementById("music");
    animateBoxUpdate(musicBox, () => {
      document.getElementById("track-status").textContent = "🎧 Music unavailable";
      document.getElementById("track-name").textContent = "";
      document.getElementById("album-art").src = "";
    });
  }
}

// ------------------------
// Twitch Stream Status
// ------------------------
async function updateTwitchStatus() {
  try {
    const res = await fetch("https://decapi.me/twitch/uptime/raych_com");
    const text = await res.text();

    const el = document.getElementById("twitch-status");
    animateBoxUpdate(el, () => {
      if (text.includes("offline")) {
        el.innerHTML = `<a href="https://www.twitch.tv/raych_com" target="_blank" rel="noopener">🐠 🐢 Aquarium stream offline</a>`;
        el.classList.remove("live", "animate");
      } else {
        el.innerHTML = `<a href="https://www.twitch.tv/raych_com" target="_blank" rel="noopener">🐠 🐢 Live on Twitch (<span class="duration">${text}</span>)</a>`;
        el.classList.add("live", "animate");
      }
    });

  } catch {
    const el = document.getElementById("twitch-status");
    animateBoxUpdate(el, () => {
      el.textContent = "🐠 Stream status unavailable";
      el.classList.remove("live", "animate");
    });
  }
}

// Initial load + intervals
updateNowPlaying();
updateTwitchStatus();
setInterval(updateNowPlaying, REFRESH_MS);
setInterval(updateTwitchStatus, 60000);
</script>