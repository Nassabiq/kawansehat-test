import { defineStore } from 'pinia';
import { ref } from 'vue';

export const useFileStore = defineStore('fileStore', () => {
  const folders = ref({
    Home: {
      Documents: {
        Reports: {},
        Invoices: {}
      },
      Music: {
        Rock: {},
        Pop: {}
      },
      Pictures: {
        Vacations: {},
        Family: {}
      }
    }
  });
  const selectedFolder = ref('Home');
  const expandedFolders = ref(new Set());
  const searchQuery = ref('');

  const toggleFolder = (folderName) => {
    if (expandedFolders.value.has(folderName)) {
      expandedFolders.value.delete(folderName);
    } else {
      expandedFolders.value.add(folderName);
    }
    selectedFolder.value = folderName;
  };

  const goBack = () => {
    const path = selectedFolder.value.split('/');
    path.pop();
    selectedFolder.value = path.join('/') || 'Home';
  };

  return { folders, selectedFolder, expandedFolders, toggleFolder, goBack, searchQuery };


  // const fetchFolders = async () => {
  //     try {
  //         const response = await axios.get('/api/folders');
  //         folders.value = response.data;
  //     } catch (error) {
  //         console.error('Error fetching folders:', error);
  //     }
  // };

  // onMounted(fetchFolders);
});
