<script setup lang="ts">
import { useFileStore } from '@/stores/file.ts'
import { computed, ref } from 'vue'
import FolderItems from './components/FolderItems.vue'

const folderStore = useFileStore()
const searchQuery = ref('')

const modalCreateFolder = ref(false)
const modalCreateFile = ref(false)

// FORM
const folder_name = ref('')

const message = ref('')
const success = ref(false)

// LAYOUT GRID / LIST
const isGridLayout = ref(false)

const createFolder = async () => {
  if (!folder_name.value.trim()) {
    message.value = 'Folder name cannot be empty.'
    success.value = false
    return
  }

  const res = await folderStore.createFolder(folderStore.selectedFolderId, folder_name.value)
  showMessage(res.message, res.success)

  if (res.success) {
    folder_name.value = '' // Clear input after successful creation
  }

  folderStore.fetchFolders()
  folderStore.getContents(folderStore.selectedFolderId)
  closeModal()
}

const updateFolder = async () => {
  if (!folder_name.value.trim()) {
    message.value = 'Folder name cannot be empty.'
    success.value = false
    return
  }

  const res = await folderStore.updateFolder(editId.value, folder_name.value)
  console.log(res)
  showMessage(res.message, res.success)

  if (res.success) {
    folder_name.value = '' // Clear input after successful creation
  }

  folderStore.fetchFolders()
  folderStore.getContents(folderStore.selectedFolderId)
  closeModal()
}

const file_name = ref<File | null>(null)
const handleUploadFile = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (input.files && input.files.length > 0) {
    file_name.value = input.files[0]
    message.value = ''
  }
}
const createFile = async () => {
  if (!file_name.value) return

  const folderIdValue =
    folderStore.selectedFolderId !== null ? folderStore.selectedFolderId.toString() : '1'

  const formData = new FormData()
  formData.append('file', file_name.value)
  formData.append('folderId', folderIdValue)

  const res = await folderStore.createFile(formData)
  showMessage(res.message, res.success)

  if (res.success) {
    file_name.value = null // Clear input after successful creation
  }

  folderStore.fetchFolders()
  folderStore.getContents(folderStore.selectedFolderId)
  closeModal()
}

const showMessage = (msg: string, isSuccess: boolean) => {
  message.value = msg
  success.value = isSuccess

  // Clear message after 3 seconds
  setTimeout(() => {
    message.value = ''
    success.value = false
  }, 3000)
}

const isEditing = ref(false)
const editId = ref(0)

const editFolder = (name: string, id: any) => {
  modalCreateFolder.value = true
  isEditing.value = true

  editId.value = id
  folder_name.value = name
}

const closeModal = () => {
  modalCreateFolder.value = false
  modalCreateFile.value = false

  isEditing.value = false
  folder_name.value = ''
}

const clickFolder = (folder: any) => {
  const { folderPath, folderId } = folder

  folderStore.setSelectedFolder(folderPath, folderId)
  folderStore.toggleFolder(folderPath)

  folderStore.getContents(folderId)
}

const goBack = () => {
  if (folderStore.selectedFolder) {
    const parentFolder = folderStore.selectedFolder.split('/').slice(0, -1).join('/')
    folderStore.setSelectedFolder(parentFolder, folderStore.contents.parentId)

    const contentId = folderStore.contents.parentId
      ? folderStore.contents.parentId
      : folderStore.selectedFolderId

    if (folderStore.selectedFolderId) {
      folderStore.getContents(contentId)
    }
  }
}
</script>

<template>
  <div class="flex h-screen">
    <!-- Left Panel -->
    <div class="w-1/5 bg-gray-200 p-4 overflow-y-auto space-y-4">
      <div class="relative">
        <div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
          <svg
            class="w-4 h-4 text-gray-500 dark:text-gray-400"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 20 20"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"
            />
          </svg>
        </div>
        <input
          type="search"
          v-model="searchQuery"
          id="folder-search"
          class="block w-full p-4 ps-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500"
          placeholder="Search..."
          required
        />
      </div>

      <!-- CONTENT LEFT PANEL -->
      <ul>
        <template v-for="(folder, index) in folderStore.folders" :key="index">
          <li
            class="cursor-pointer p-2 hover:bg-gray-300 flex items-center"
            @click="clickFolder({ folderPath: folder.name, folderId: folder.id })"
          >
            <span class="mr-2" v-if="folder.subFolders.length > 0">
              {{ folderStore.expandedFolders.has(folder.name) ? '▼' : '▶' }}
            </span>
            📁
            {{ folder.name }}
          </li>
          <ul v-if="folderStore.expandedFolders.has(folder.name)" class="pl-4">
            <FolderItems
              v-for="(nestedSubFolders, subIndex) in folder.subFolders"
              :key="subIndex"
              :folder="nestedSubFolders.name"
              :subFolders="nestedSubFolders"
              :path="folder.name"
              @folder-click="clickFolder"
            />
          </ul>
        </template>
      </ul>
    </div>

    <!-- RIGHT PANEL -->
    <div class="w-4/5 bg-white p-4 space-y-4">
      <div class="flex items-center justify-between mb-8">
        <div class="flex items-center gap-4">
          <button
            type="button"
            @click="goBack"
            class="p-2 bg-gray-100 flex items-center gap-4 hover:bg-sky-200 hover:font-semibold rounded mr-2 cursor-pointer"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-5 h-5"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"
              />
            </svg>

            Back
          </button>
          <h2 class="text-lg font-semibold">
            Folder: {{ folderStore.selectedFolder || 'Select a folder' }}
          </h2>
        </div>
        <div class="flex items-center gap-2">
          <!-- ADD NEW FOLDER -->
          <button
            type="button"
            @click="modalCreateFolder = !modalCreateFolder"
            class="text-white bg-sky-600 flex items-center gap-4 hover:bg-sky-700 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-5 h-5"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M12 10.5v6m3-3H9m4.06-7.19-2.12-2.12a1.5 1.5 0 0 0-1.061-.44H4.5A2.25 2.25 0 0 0 2.25 6v12a2.25 2.25 0 0 0 2.25 2.25h15A2.25 2.25 0 0 0 21.75 18V9a2.25 2.25 0 0 0-2.25-2.25h-5.379a1.5 1.5 0 0 1-1.06-.44Z"
              />
            </svg>

            Add New Folder
          </button>

          <!-- ADD NEW FILE -->
          <button
            type="button"
            @click="modalCreateFile = !modalCreateFile"
            class="text-white bg-lime-600 flex items-center gap-4 hover:bg-lime-700 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-5 h-5"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m3.75 9v6m3-3H9m1.5-12H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z"
              />
            </svg>

            Add New File
          </button>
        </div>
      </div>

      <!--  CONTENT RIGHT PANEL -->
      <div class="flex justify-end mb-4">
        <button
          class="px-4 py-2 text-sm font-medium bg-gray-200 rounded-l hover:bg-gray-300"
          :class="{ 'bg-blue-500 text-white': isGridLayout }"
          @click="isGridLayout = true"
        >
          Grid
        </button>
        <button
          class="px-4 py-2 text-sm font-medium bg-gray-200 rounded-r hover:bg-gray-300"
          :class="{ 'bg-blue-500 text-white': !isGridLayout }"
          @click="isGridLayout = false"
        >
          List
        </button>
      </div>

      <div
        v-if="folderStore.contents && folderStore.selectedFolderId"
        :class="isGridLayout ? 'grid grid-cols-4 gap-4' : 'flex flex-col space-y-4'"
      >
        <template v-for="subFolder in folderStore.contents.folders" :key="subFolder.id">
          <button
            type="button"
            class="p-4 bg-gray-100 rounded shadow cursor-pointer hover:bg-gray-200"
            :class="isGridLayout ? 'text-center' : 'text-left flex justify-between items-center'"
            @click="
              clickFolder({
                folderPath: `${folderStore.selectedFolder}/${subFolder.name}`,
                folderId: subFolder.id,
              })
            "
          >
            <div class="flex items-center gap-2">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-5 h-5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M2.25 12.75V12A2.25 2.25 0 0 1 4.5 9.75h15A2.25 2.25 0 0 1 21.75 12v.75m-8.69-6.44-2.12-2.12a1.5 1.5 0 0 0-1.061-.44H4.5A2.25 2.25 0 0 0 2.25 6v12a2.25 2.25 0 0 0 2.25 2.25h15A2.25 2.25 0 0 0 21.75 18V9a2.25 2.25 0 0 0-2.25-2.25h-5.379a1.5 1.5 0 0 1-1.06-.44Z"
                />
              </svg>
              {{ subFolder.name }}
            </div>
            <div class="flex item-center gap-1" v-if="!isGridLayout">
              <button
                type="button"
                @click.stop="editFolder(subFolder.name, subFolder.id)"
                class="text-white bg-sky-600 hover:bg-sky-700 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-3 py-1.5"
              >
                Edit
              </button>
              <!-- <button
                type="button"
                @click="modalCreateFolder = !modalCreateFolder"
                class="text-white bg-red-600 hover:bg-red-700 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-3 py-1.5"
              >
                Delete
              </button> -->
            </div>
          </button>
        </template>

        <template v-for="file in folderStore.contents.files" :key="file.id">
          <div
            class="p-4 bg-gray-100 rounded shadow"
            :class="isGridLayout ? 'text-center' : 'text-left'"
          >
            <div class="flex items-center text-sm gap-2">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-5 h-5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25M9 16.5v.75m3-3v3M15 12v5.25m-4.5-15H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z"
                />
              </svg>
              {{ file.name }} ({{ file.type }}, {{ file.size }})
            </div>
          </div>
        </template>
      </div>
      <p v-else class="text-gray-500">Select Folders or Files</p>
    </div>

    <!-- MODAL CREATE / EDIT FOLDER -->
    <div
      v-show="modalCreateFolder"
      id="modal"
      tabindex="-1"
      aria-hidden="true"
      class="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto overflow-x-hidden"
    >
      <div class="relative p-4 w-full max-w-2xl max-h-full">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow-sm">
          <!-- Modal header -->
          <div
            class="flex items-center justify-between p-4 md:p-5 border-b rounded-t border-gray-200"
          >
            <h3 class="text-xl font-semibold text-gray-900">
              {{ isEditing ? 'Edit Folder' : 'Add Folder' }}
            </h3>
            <button
              @click="closeModal"
              type="button"
              class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center"
            >
              <svg
                class="w-3 h-3"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 14"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
                />
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <!-- Modal body -->
          <div class="p-4 md:p-5 space-y-4">
            <input type="hidden" v-model="editId" v-if="isEditing" />
            <div>
              <label for="email" class="block mb-2 text-sm font-medium text-gray-900">
                Nama Folder
              </label>
              <input
                type="text"
                name="folder_name"
                v-model="folder_name"
                id="folder_name"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
                placeholder="Folder Name ..."
                required
              />
              <p
                v-if="message"
                class="mt-2 text-xs"
                :class="{ 'text-green-500': success, 'text-red-500': !success }"
              >
                {{ message }}
              </p>
            </div>
          </div>
          <!-- Modal footer -->
          <div class="flex items-center p-4 md:p-5 border-t border-gray-200 rounded-b">
            <button
              @click="isEditing ? updateFolder() : createFolder()"
              type="button"
              class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center"
            >
              {{ isEditing ? 'Update' : 'Submit' }}
            </button>
            <button
              @click="closeModal"
              data-modal-hide="default-modal"
              type="button"
              class="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100"
            >
              Back
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- MODAL CREATE FILE -->
    <div
      v-show="modalCreateFile"
      id="modal"
      tabindex="-1"
      aria-hidden="true"
      class="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto overflow-x-hidden"
    >
      <div class="relative p-4 w-full max-w-2xl max-h-full">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow-sm">
          <!-- Modal header -->
          <div
            class="flex items-center justify-between p-4 md:p-5 border-b rounded-t border-gray-200"
          >
            <h3 class="text-xl font-semibold text-gray-900">Add File</h3>
            <button
              @click="closeModal"
              type="button"
              class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center"
            >
              <svg
                class="w-3 h-3"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 14"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
                />
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <!-- Modal body -->
          <div class="p-4 md:p-5 space-y-4">
            <div>
              <label class="block mb-2 text-sm font-medium text-gray-900" for="file_input">
                Upload file
              </label>
              <input
                class="block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none"
                id="file_input"
                @change="handleUploadFile"
                type="file"
              />
            </div>
          </div>
          <!-- Modal footer -->
          <div class="flex items-center p-4 md:p-5 border-t border-gray-200 rounded-b">
            <button
              @click="createFile"
              type="button"
              class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center"
            >
              Submit
            </button>
            <button
              @click="closeModal"
              data-modal-hide="default-modal"
              type="button"
              class="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100"
            >
              Back
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
