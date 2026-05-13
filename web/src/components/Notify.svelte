<script>
  import { onMount } from "svelte";
  import { flip } from "svelte/animate";
  import { fly, fade } from "svelte/transition";
  import { notifications, position, removeNotification } from "../store.js";

  const MAX_VISIBLE = 3;

  $: visibleNotifications = $notifications.slice(-MAX_VISIBLE);

  $: containerClasses = getContainerClasses($position);
  $: flyParams = getFlyParams($position);
  $: isBottom = $position.startsWith("bottom");
  $: isCenter = $position === "top-center" || $position === "bottom-center";
  $: barOnRight = $position.includes("right");

  function getContainerClasses(pos) {
    const base = "fixed z-[9999] flex flex-col gap-2 pointer-events-none";
    const map = {
      "top-left": "top-4 left-4 items-start",
      "top-center": "top-4 left-1/2 -translate-x-1/2 items-center",
      "top-right": "top-4 right-4 items-end",
      "center-left": "top-1/2 -translate-y-1/2 left-4 items-start",
      "center-right": "top-1/2 -translate-y-1/2 right-4 items-end",
      "bottom-left": "bottom-4 left-4 items-start",
      "bottom-center": "bottom-4 left-1/2 -translate-x-1/2 items-center",
      "bottom-right": "bottom-4 right-4 items-end",
    };
    return `${base} ${map[pos] || map["top-right"]}`;
  }

  function getFlyParams(pos) {
    if (pos.includes("left")) return { x: -300, duration: 400 };
    if (pos.includes("right")) return { x: 300, duration: 400 };
    if (pos.startsWith("top")) return { y: -80, duration: 400 };
    return { y: 80, duration: 400 };
  }

  function dismiss(id) {
    removeNotification(id);
  }

  function getElapsed(notif) {
    return Date.now() - notif.createdAt;
  }
</script>

<div
  class={containerClasses}
  style={isBottom ? "flex-direction: column-reverse;" : ""}
>
  {#each visibleNotifications as notif (notif.id)}
    <div
      class="pointer-events-auto w-[16rem] rounded-md shadow-2xl overflow-hidden transition-transform duration-150 active:scale-[0.98] flex"
      class:flex-row-reverse={barOnRight}
      class:flex-col={isCenter}
      style="background: {notif.styling.background};"
      in:fly={flyParams}
      out:fade={{ duration: 200 }}
      animate:flip={{ duration: 300 }}
      role="alert"
    >
      {#if !isCenter}
        <div
          class="flex-shrink-0 flex items-center py-2"
          class:pl-2={!barOnRight}
          class:pr-2={barOnRight}
        >
          <div
            class="w-[3px] h-full rounded-full bg-white/[0.06] relative overflow-hidden"
          >
            <div
              class="absolute bottom-0 left-0 w-full rounded-full notify-progress-vertical"
              style="background: {notif.styling
                .text_color}; animation-duration: {notif.duration -
                getElapsed(notif)}ms;"
            ></div>
          </div>
        </div>
      {/if}

      <div class="flex items-center gap-3 px-3.5 py-3 flex-1 min-w-0">
        <div
          class="flex-shrink-0 text-[1rem]"
          style="color: {notif.styling.icon_color};"
        >
          <i class={notif.icon}></i>
        </div>

        <div class="flex-1 min-w-0">
          <div
            class="text-[0.75rem] font-bold uppercase tracking-wider leading-tight"
            style="color: {notif.styling.text_color};"
          >
            {notif.title}
          </div>
          <div
            class="text-[0.7rem] leading-snug text-white/70 break-words mt-0.5"
          >
            {notif.message}
          </div>
        </div>
      </div>

      {#if isCenter}
        <div class="flex-shrink-0 px-2 pb-2">
          <div
            class="h-[3px] w-full rounded-full bg-white/[0.06] relative overflow-hidden"
          >
            <div
              class="absolute left-0 top-0 h-full rounded-full notify-progress-horizontal"
              style="background: {notif.styling
                .text_color}; animation-duration: {notif.duration -
                getElapsed(notif)}ms;"
            ></div>
          </div>
        </div>
      {/if}
    </div>
  {/each}
</div>

<style>
  .notify-progress-vertical {
    animation: shrink-vertical linear forwards;
    height: 100%;
  }

  @keyframes shrink-vertical {
    from {
      height: 100%;
    }
    to {
      height: 0%;
    }
  }

  .notify-progress-horizontal {
    animation: shrink-horizontal linear forwards;
    width: 100%;
  }

  @keyframes shrink-horizontal {
    from {
      width: 100%;
    }
    to {
      width: 0%;
    }
  }
</style>
