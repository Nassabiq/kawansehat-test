import { defineStore } from 'pinia';
import { onMounted, ref } from 'vue';

interface FolderStructure {
  [key: string]: FolderStructure;
}

interface FileStructure {
  [key: string]: { type: string; size: string } | FileStructure;
}

export const useFileStore = defineStore('fileStore', () => {

  const folders = ref<Record<string, any>>({});
  const files_in_folder = ref<Record<string, any>>({});
  const expandedFolders = ref<Set<string>>(new Set());

  const selectedFolder = ref<string | null>(null);
  const selectedFolderId = ref<number | null>(null);

  const contents = ref<any | null>(null);

  const fetchFolders = async (): Promise<void> => {
    try {
      const req = await fetch('http://localhost:3000/api/v1/folders');
      const res = await req.json();

      folders.value = res.data;
    } catch (error) {
      console.error('Failed to fetch folders:', error);
    }
  }

  const toggleFolder = (folder: string) => {
    if (expandedFolders.value.has(folder)) {
      expandedFolders.value.delete(folder);
    } else {
      expandedFolders.value.add(folder);
    }
  }

  const setSelectedFolder = (folder: string | null, folderId: number | null) => {
    selectedFolder.value = folder;
    selectedFolderId.value = folderId;
  }

  const getContents = async (folderId: number | null): Promise<void> => {
    try {
      const req = await fetch('http://localhost:3000/api/v1/folders/' + folderId)
      const res = await req.json()

      const currentFolders = res.data.subFolders
      const currentFiles = res.data.File

      const files: Record<string, { type: string; size: string }> = {};
      for (const [key, value] of Object.entries(currentFiles)) {
        if (typeof value === 'object') {
          files[key] = value as { type: string; size: string };
        }
      }

      contents.value = {
        folders: currentFolders,
        files,
        parentId: res?.data.parentId
      }

    } catch (error) {
      console.error('Failed to fetch folders:', error);
    }
  }

  const createFolder = async (parentId: number | null, folder_name: string) => {
    try {
      const response = await fetch('http://localhost:3000/api/v1/folders', {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ name: folder_name, parentId: parentId }),
      })

      if (!response.ok) {
        throw new Error(`Failed to create folder: ${response.statusText}`);
      }

      const result = await response.json();
      return {
        success: true,
        message: "Folder created successfully",
        data: result,
      };

    } catch (error: any) {
      console.error("Error creating folder:", error.message);
      return {
        success: false,
        message: error.message,
      };
    }
  }

  const updateFolder = async (id: number, folder_name: string) => {
    try {
      const response = await fetch('http://localhost:3000/api/v1/folders/' + id, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ name: folder_name }),
      })

      if (!response.ok) {
        throw new Error(`Failed to create folder: ${response.statusText}`);
      }

      const result = await response.json();
      return {
        success: true,
        message: "Folder updated successfully",
        data: result,
      };

    } catch (error: any) {
      console.error("Error updating folder:", error.message);
      return {
        success: false,
        message: error.message,
      };
    }
  }

  const createFile = async (form: any) => {
    try {
      const response = await fetch('http://localhost:3000/api/v1/files', {
        method: "POST",
        body: form,
      })

      if (!response.ok) {
        throw new Error(`Failed to create files: ${response.statusText}`);
      }

      const result = await response.json();
      return {
        success: true,
        message: "Files created successfully",
        data: result,
      };

    } catch (error: any) {
      console.error("Error creating files:", error.message);
      return {
        success: false,
        message: error.message,
      };
    }
  }

  onMounted(() => {
    fetchFolders();
  });

  return {
    folders,
    files_in_folder,
    expandedFolders,
    selectedFolder,
    selectedFolderId,
    contents,
    fetchFolders,
    toggleFolder,
    setSelectedFolder,
    getContents,
    createFolder,
    updateFolder,
    createFile
  };
});
