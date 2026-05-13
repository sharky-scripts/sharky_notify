<script>
  import { onMount } from "svelte";
  import {
    notifications,
    position,
    positionEditorVisible,
    addNotification,
  } from "./store.js";
  import Notify from "./components/Notify.svelte";
  import NotifyPositionEditor from "./components/NotifyPositionEditor.svelte";

  onMount(() => {
    window.addEventListener("message", handleMessage);

    if (import.meta.env.DEV) {
      setTimeout(() => {
        addNotification({
          message: "Lorem, ipsum dolor sit amet consectetur adipisicing elit.",
          title: "Információ",
          notifyType: "info",
          duration: 5000,
          config: {
            icon: "fas fa-info-circle",
            styling: {
              background: "#202727e6",
              text_color: "#3498db",
              icon_color: "#3498db",
            },
          },
        });
      }, 500);

      setTimeout(() => {
        addNotification({
          message: "Lorem, ipsum dolor sit amet consectetur adipisicing elit.",
          title: "Hiba",
          notifyType: "error",
          duration: 5000,
          config: {
            icon: "fas fa-exclamation-circle",
            styling: {
              background: "#202727e6",
              text_color: "#e74c3c",
              icon_color: "#e74c3c",
            },
          },
        });
      }, 1200);

      setTimeout(() => {
        addNotification({
          message: "Lorem, ipsum dolor sit amet consectetur adipisicing elit.",
          title: "Siker",
          notifyType: "success",
          duration: 5000,
          config: {
            icon: "fas fa-check-circle",
            styling: {
              background: "#202727e6",
              text_color: "#2ecc71",
              icon_color: "#2ecc71",
            },
          },
        });
      }, 1900);
    }

    return () => {
      window.removeEventListener("message", handleMessage);
    };
  });

  function handleMessage(event) {
    const data = event.data;
    if (!data || typeof data !== "object") return;

    if (data.type === "notify") {
      addNotification(data);
    }

    if (data.type === "openPositionEditor") {
      positionEditorVisible.set(true);
    }

    if (data.type === "closePositionEditor") {
      positionEditorVisible.set(false);
    }

    if (data.type === "setPosition") {
      position.set(data.position || "top-right");
    }
  }
</script>

<Notify />
<NotifyPositionEditor />
