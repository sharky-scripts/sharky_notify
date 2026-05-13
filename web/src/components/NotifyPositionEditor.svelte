<script>
  import { fly, fade } from "svelte/transition";
  import {
    position,
    positionEditorVisible,
    addNotification,
  } from "../store.js";
  import { postNui } from "../lib/nui.js";

  const positions = [
    { id: "top-left", label: "Bal felül", row: 1, col: 1 },
    { id: "top-center", label: "Középen felül", row: 1, col: 2 },
    { id: "top-right", label: "Jobb felül", row: 1, col: 3 },
    { id: "center-left", label: "Bal középen", row: 2, col: 1 },
    { id: "center-right", label: "Jobb középen", row: 2, col: 3 },
    { id: "bottom-left", label: "Bal alul", row: 3, col: 1 },
    { id: "bottom-center", label: "Középen alul", row: 3, col: 2 },
    { id: "bottom-right", label: "Jobb alul", row: 3, col: 3 },
  ];

  function selectPosition(id) {
    position.set(id);
    addNotification({
      message: "Értesítések most itt fognak megjelenni.",
      title: "Pozíció frissítve",
      notifyType: "success",
      duration: 2500,
      config: {
        icon: "fas fa-check-circle",
        styling: {
          background: "#202727e6",
          text_color: "#2ecc71",
          icon_color: "#2ecc71",
        },
      },
    });
  }

  function save() {
    postNui("savePosition", { position: $position }).catch(() => {});
    positionEditorVisible.set(false);
  }

  function close() {
    postNui("closePositionEditor", {}).catch(() => {});
    positionEditorVisible.set(false);
  }

  function getPositionIcon(id) {
    const icons = {
      "top-left": "fas fa-arrow-up -rotate-45",
      "top-center": "fas fa-arrow-up",
      "top-right": "fas fa-arrow-up rotate-45",
      "center-left": "fas fa-arrow-left",
      "center-right": "fas fa-arrow-right",
      "bottom-left": "fas fa-arrow-down rotate-45",
      "bottom-center": "fas fa-arrow-down",
      "bottom-right": "fas fa-arrow-down -rotate-45",
    };
    return icons[id] || "fas fa-circle";
  }
</script>

{#if $positionEditorVisible}
  <div class="fixed inset-0 z-[10000]" transition:fade={{ duration: 200 }}>
    <div class="absolute inset-0 bg-black/60"></div>

    <div
      class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center pointer-events-none z-10"
    >
      <h2 class="text-white text-[1.1rem] font-bold tracking-wide">
        Értesítés pozíciója
      </h2>
      <p class="text-white/40 text-[0.72rem] mt-1">
        Válaszd ki hol jelenjenek meg az értesítések
      </p>

      <div class="flex justify-center gap-2 mt-5 pointer-events-auto">
        <button
          class="px-5 py-2 rounded-md text-[0.75rem] font-semibold tracking-wide
                 border border-white/[0.08] bg-white/[0.04] text-white/50
                 hover:border-red-500/30 hover:bg-red-500/10 hover:text-red-400
                 transition-all duration-200"
          on:click={close}
        >
          <i class="fas fa-times mr-1.5"></i>
          Bezárás
        </button>
        <button
          class="px-5 py-2 rounded-md text-[0.75rem] font-semibold tracking-wide
                 border border-[#3498db]/30 bg-[#3498db]/15 text-[#3498db]
                 hover:bg-[#3498db]/25 hover:border-[#3498db]/50 hover:shadow-lg hover:shadow-[#3498db]/10
                 transition-all duration-200"
          on:click={save}
        >
          <i class="fas fa-save mr-1.5"></i>
          Mentés
        </button>
      </div>
    </div>

    {#each positions as pos}
      <button
        class="absolute z-10 w-[16rem] rounded-lg border
               overflow-hidden cursor-pointer transition-all duration-200
               {$position === pos.id
          ? 'border-[#3498db]/60 bg-[#3498db]/10 shadow-lg shadow-[#3498db]/20'
          : 'border-white/[0.06] bg-white/[0.04] hover:border-white/[0.15] hover:bg-white/[0.08]'}
               {pos.id === 'top-left' ? 'top-4 left-4' : ''}
               {pos.id === 'top-center'
          ? 'top-4 left-1/2 -translate-x-1/2'
          : ''}
               {pos.id === 'top-right' ? 'top-4 right-4' : ''}
               {pos.id === 'center-left'
          ? 'left-4 top-1/2 -translate-y-1/2'
          : ''}
               {pos.id === 'center-right'
          ? 'right-4 top-1/2 -translate-y-1/2'
          : ''}
               {pos.id === 'bottom-left' ? 'bottom-4 left-4' : ''}
               {pos.id === 'bottom-center'
          ? 'bottom-4 left-1/2 -translate-x-1/2'
          : ''}
               {pos.id === 'bottom-right' ? 'bottom-4 right-4' : ''}"
        in:fly={{
          y: pos.row === 1 ? -40 : 40,
          duration: 350,
          delay: pos.col * 60,
        }}
        out:fade={{ duration: 200 }}
        on:click={() => selectPosition(pos.id)}
      >
        <div class="flex items-start gap-3 p-3.5">
          <div
            class="flex-shrink-0 mt-0.5 text-[1.15rem] transition-colors duration-200
                   {$position === pos.id ? 'text-[#3498db]' : 'text-white/25'}"
          >
            <i class={getPositionIcon(pos.id)}></i>
          </div>
          <div class="flex-1 min-w-0">
            <div
              class="text-[0.8rem] font-semibold tracking-wide leading-tight mb-0.5 transition-colors duration-200
                     {$position === pos.id
                ? 'text-[#3498db]'
                : 'text-white/70'}"
            >
              {pos.label}
            </div>
            <div class="text-[0.72rem] leading-snug text-white/40">
              Kattints a kiválasztáshoz
            </div>
          </div>
          {#if $position === pos.id}
            <div class="flex-shrink-0 mt-1">
              <div
                class="w-2.5 h-2.5 rounded-full bg-[#3498db] animate-pulse"
              ></div>
            </div>
          {/if}
        </div>
        <div class="h-[2px] w-full bg-white/[0.05]">
          <div
            class="h-full transition-all duration-300
                   {$position === pos.id ? 'w-full bg-[#3498db]' : 'w-0'}"
          ></div>
        </div>
      </button>
    {/each}
  </div>
{/if}
