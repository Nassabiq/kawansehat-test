import { Folder, PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

const getAllFolders = async (): Promise<any> => {
    const allFolders = await prisma.folder.findMany({
        include: {
            parent: true,
            // File: true
        }
    })

    const results = (parentId: number | null): any[] => {
        return allFolders
            .filter((folder) => folder.parentId === parentId)
            .map(folder => ({
                ...folder,
                subFolders: results(folder.id)
            }))
    }

    return results(null)
}

const getSelectedFolder = async (id: number): Promise<any> => {
    return await prisma.folder.findUnique({
        where: {
            id: id
        },
        include: {
            parent: true,
            File: true,
            subFolders: true
        }
    })
}

interface CreateFolderForm {
    parentId: number | null,
    name: string,
    created_at: number,
    updated_at: number,
}

const postFolder = async (form: CreateFolderForm): Promise<any> => {
    return await prisma.folder.create({
        data: {
            parentId: form.parentId,
            name: form.name,
            created_at: new Date(),
            updated_at: new Date(),
        },
    })
}

interface CreateFileForm {
    folderId: number,
    name: string,
    type: string,
    size: string,
    created_at: number,
    updated_at: number,
}

const postFile = async (form: CreateFileForm): Promise<any> => {
    console.log(form)
    return await prisma.file.create({
        data: {
            folderId: form.folderId,
            name: form.name,
            type: form.type,
            size: form.size,
            created_at: new Date(),
            updated_at: new Date(),
        },
    })
}

const putFolder = async (id: number, form: any): Promise<any> => {
    return await prisma.folder.update({
        where: {
            id: id
        },
        data: {
            parentId: form.parentId,
            name: form.name,
        }
    })
}

export { getAllFolders, getSelectedFolder, postFolder, putFolder, postFile }