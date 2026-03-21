(function () {
    if (!document.querySelector) return;
    if (navigator.userAgent.indexOf("Google Page Speed") !== -1) return;
    if (document.cookie.indexOf("has_seen_country_message") !== -1) return;
  
    // Minimal ISO country name map (extend as you like)
    var countryNames = {
      US: "the United States",
      GB: "the United Kingdom",
      KE: "Kenya",
      CA: "Canada",
      AU: "Australia",
      DE: "Germany",
      FR: "France",
      NL: "the Netherlands",
      ZA: "South Africa",
      IN: "India",
      NG: "Nigeria"
    };
  
    fetch("https://country.is/")
      .then(function (r) { return r.ok ? r.json() : null; })
      .then(function (data) {
        if (!data || !data.country) return;
  
        var code = data.country.trim();
        if (code === "KE") return; // local users, no banner
  
        var countryLabel = countryNames[code] || "another country";
  
        var banner = document.createElement("div");
        banner.className = "top_banner top_banner--country";
  
        var close = document.createElement("a");
        close.className = "top_banner__close";
        close.href = "#";
        close.innerHTML = "Close";
        close.onclick = function (e) {
          e.preventDefault();
          banner.style.display = "none";
          var t = new Date();
          t.setFullYear(t.getFullYear() + 1);
          document.cookie =
            "has_seen_country_message=1; path=/; expires=" + t.toUTCString();
        };
  
        var p = document.createElement("p");
        p.innerHTML =
        'You appear to be visiting from <strong>' + countryLabel + '</strong>. ' +
        'This platform is designed for reporting <strong>local issues across Kenya</strong> — ' +
        'from roads and waste to water and public services. ' +
        'If you’re outside Kenya, you may want a community reporting site for your own location.';
      
  
        banner.appendChild(close);
        banner.appendChild(p);
        document.body.insertBefore(banner, document.body.firstChild);
        banner.style.display = "block";
      })
      .catch(function () {
        // silent fail — never block page load
      });
  })();
  