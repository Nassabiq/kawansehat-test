import { Elysia } from "elysia";
import { getFolders, findFolder, createFolder, updateFolder, createFile } from "../services/FolderService";

export const FolderController = new Elysia()
    .get("/folders", async () => {
        try {
            const folders = await getFolders();
            return { status: "success", data: folders };
        } catch (error) {
            return { status: "error", message: "Failed to fetch folders", error };
        }
    })
    .get("/folders/:id", async (ctx) => {
        try {
            const folderId = parseInt(ctx.params.id);
            const folder = await findFolder(folderId);

            if (!folder) {
                return { status: "error", message: `Folder with ID ${folderId} not found` };
            }

            return { status: "success", data: folder };
        } catch (error) {
            return { status: "error", message: "Failed to fetch folder", error };
        }
    })
    .post("/folders", async (ctx) => {
        try {
            const folderData = ctx.body;
            const newFolder = await createFolder(folderData);

            return { status: "success", message: "Folder created successfully", data: newFolder };
        } catch (error) {
            return { status: "error", message: "Failed to create folder", error };
        }
    })
    .post("/files", async (ctx: any) => {
        const file = ctx.body.file
        const folderId = ctx.body.folderId

        const filename = file.name
        let filetype = ''

        if (filename.includes('.')) {
            filetype = filename.split('.').pop()
        }

        const filePath = 'public/' + filename
        await Bun.write(Bun.file(filePath), file);

        try {
            const request = {
                name: filename,
                type: filetype,
                size: file.size.toString(),
                folderId: parseInt(folderId)
            };

            const newFile = await createFile(request);
            return { status: "success", message: "File created successfully", data: newFile };
        } catch (error) {
            return { status: "error", message: "Failed to create file", error };
        }
    })
    .put("/folders/:id", async (ctx) => {
        try {
            const folderId = parseInt(ctx.params.id)
            const folderData = ctx.body
            const updatedFolder = await updateFolder(folderId, folderData);

            if (!updatedFolder) {
                return { status: "error", message: `Folder with ID ${folderId} not found` };
            }

            return { status: "success", message: "Folder updated successfully", data: updatedFolder };
        } catch (error) {
            return { status: "error", message: "Failed to update folder", error };
        }
    })
