import { writable, derived } from "svelte/store";

export const notifications = writable([]);
export const position = writable("top-right");
export const positionEditorVisible = writable(true);

let idCounter = 0;

export function addNotification(data) {
  const id = ++idCounter;
  const notification = {
    id,
    message: data.message || "",
    title: data.title || "Notification",
    notifyType: data.notifyType || "info",
    duration: data.duration || data.config?.defaultDuration || 5000,
    icon: data.config?.icon || "fas fa-info-circle",
    styling: {
      background: data.config?.styling?.background || "#202727e6",
      text_color: data.config?.styling?.text_color || "#3498db",
      icon_color: data.config?.styling?.icon_color || "#3498db",
    },
    createdAt: Date.now(),
  };

  notifications.update((n) => [...n, notification]);

  setTimeout(() => {
    removeNotification(id);
  }, notification.duration);

  return id;
}

export function removeNotification(id) {
  notifications.update((n) => n.filter((notif) => notif.id !== id));
}
