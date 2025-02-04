<template>
  <!-- {{ subFolders.subFolders }} -->
  <li class="cursor-pointer p-2 hover:bg-gray-300 flex items-center" @click.stop="handleClick">
    <span class="mr-2" v-if="subFolders.subFolders.length > 0">
      {{ expanded ? '▼' : '▶' }}
    </span>
    📁
    {{ folder }}
  </li>

  <ul v-if="expanded" class="pl-4">
    <FolderItems
      v-for="(nestedSubFolders, index) in subFolders.subFolders"
      :key="index"
      :folder="nestedSubFolders.name"
      :subFolders="nestedSubFolders"
      :path="`${path}/${subFolders.name}`"
      @folder-click="$emit('folder-click', $event)"
    />
  </ul>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useFileStore } from '../stores/file.ts'

const props = defineProps({
  folder: { type: [String, Number], required: true },
  subFolders: { type: Object, required: true },
  path: { type: [String, Number], required: true },
})

const emit = defineEmits(['folder-click'])

const folderStore = useFileStore()
const expanded = computed(() => folderStore.expandedFolders.has(`${props.path}/${props.folder}`))

const handleClick = () => {
  emit('folder-click', {
    folderPath: `${props.path}/${props.folder}`,
    folderId: props.subFolders.id,
  })
}
</script>

<style scoped></style>
