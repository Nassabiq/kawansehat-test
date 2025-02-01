<script setup lang="ts">
// import { RouterLink, RouterView } from 'vue-router'
// import HelloWorld from './components/HelloWorld.vue'

import { useFileStore } from '@/stores/file'
const { folders, selectedFolder, expandedFolders, toggleFolder, goBack, searchQuery } =
  useFileStore()
</script>

<template>
  <div class="flex h-screen">
    <!-- Left Panel -->
    <div class="w-1/4 bg-gray-200 p-4 overflow-y-auto">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Search..."
        class="w-full p-2 mb-2 border rounded"
      />
      <ul>
        <template v-for="(subFolders, folder) in folders" :key="folder">
          <li
            class="cursor-pointer p-2 hover:bg-gray-300 flex items-center"
            @click="toggleFolder(folder)"
          >
            <span class="mr-2">{{ expandedFolders.has(folder) ? '▼' : '▶' }}</span> 📁 {{ folder }}
          </li>
          <ul v-if="expandedFolders.has(folder)" class="pl-4">
            <template v-for="(nestedSubFolders, subFolder) in subFolders" :key="subFolder">
              <li
                class="cursor-pointer p-2 hover:bg-gray-300 flex items-center"
                @click.stop="toggleFolder(subFolder)"
              >
                <span class="mr-2">{{ expandedFolders.has(subFolder) ? '▼' : '▶' }}</span> 📁
                {{ subFolder }}
              </li>
              <ul v-if="expandedFolders.has(subFolder)" class="pl-4">
                <template
                  v-for="(deepSubFolders, deepSubFolder) in nestedSubFolders"
                  :key="deepSubFolder"
                >
                  <li
                    class="cursor-pointer p-2 hover:bg-gray-300 flex items-center"
                    @click.stop="toggleFolder(deepSubFolder)"
                  >
                    <span class="mr-2">{{ expandedFolders.has(deepSubFolder) ? '▼' : '▶' }}</span>
                    📁 {{ deepSubFolder }}
                  </li>
                  <ul v-if="expandedFolders.has(deepSubFolder)" class="pl-4">
                    <li
                      v-for="(leafSubFolder, key) in deepSubFolders"
                      :key="key"
                      @click.stop="toggleFolder(key)"
                      class="cursor-pointer p-2 hover:bg-gray-300 flex items-center"
                    >
                      <span class="mr-2">{{ expandedFolders.has(key) ? '▼' : '▶' }}</span> 📁
                      {{ key }}
                    </li>
                  </ul>
                </template>
              </ul>
            </template>
          </ul>
        </template>
      </ul>
    </div>
    <!-- Right Panel -->
    <div class="w-3/4 bg-white p-4">
      <div class="flex items-center mb-2">
        <button @click="goBack" class="p-2 bg-gray-300 rounded mr-2">⬅ Back</button>
        <h2 class="text-lg font-semibold">
          Selected Folder: {{ selectedFolder || 'Select a folder' }}
        </h2>
      </div>
      <div v-if="folders[selectedFolder]" class="grid grid-cols-4 gap-4">
        <div
          v-for="subFolder in Object.keys(folders[selectedFolder] || {})"
          :key="subFolder"
          class="p-4 bg-gray-100 rounded shadow text-center"
        >
          📁 {{ subFolder }}
        </div>
      </div>
      <p v-else class="text-gray-500">No subfolders</p>
    </div>
  </div>
</template>

<!-- <template>
  <header>
    <img alt="Vue logo" class="logo" src="@/assets/logo.svg" width="125" height="125" />

    <div class="wrapper">
      <HelloWorld msg="You did it!" />

      <nav>
        <RouterLink to="/">Home</RouterLink>
        <RouterLink to="/about">About</RouterLink>
      </nav>
    </div>
  </header>

  <RouterView />
</template> -->

<!-- <style scoped>
header {
  line-height: 1.5;
  max-height: 100vh;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

nav {
  width: 100%;
  font-size: 12px;
  text-align: center;
  margin-top: 2rem;
}

nav a.router-link-exact-active {
  color: var(--color-text);
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid var(--color-border);
}

nav a:first-of-type {
  border: 0;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }
}
</style> -->
