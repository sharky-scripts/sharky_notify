window.addEventListener("message", function (event) {
  if (event.data.type === "notify") {
    let config = event.data.config;
    let title = event.data.title;

    let notification = document.createElement("div");
    notification.className = "notification show";
    notification.style.background = config.styling.background || "#fff";

    notification.innerHTML = `
            <div class="icon" style="color: ${config.styling.icon_color};">
                <i class="${config.icon}"></i>
            </div>
            <div class="content" style="color: ${config.styling.text_color};">
                <div class="title">${title}</div>
                <div class="message">${event.data.message}</div>
            </div>
        `;

    document.querySelector(".notification-container").appendChild(notification);

    setTimeout(function () {
      notification.classList.remove("show");
      notification.classList.add("fadeout");

      setTimeout(function () {
        notification.remove();
      }, 500);
    }, event.data.duration || config.defaultDuration);
  }
});
