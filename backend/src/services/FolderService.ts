import { getAllFolders, getSelectedFolder, postFile, postFolder, putFolder } from "../repositories/FolderRepository";
const getFolders = async (): Promise<any> => {
    return await getAllFolders()
}

const findFolder = async (id: number): Promise<any> => {
    return await getSelectedFolder(id)
}

const createFolder = async (form: any): Promise<any> => {
    return await postFolder(form)
}

const createFile = async (form: any): Promise<any> => {
    return await postFile(form)
}

const updateFolder = async (id: number, form: any): Promise<any> => {
    return await putFolder(id, form)
}

export { getFolders, findFolder, createFolder, updateFolder, createFile }