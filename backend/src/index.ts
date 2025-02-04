import { Elysia } from "elysia";
import { FolderController } from "./controllers/FolderController";
import { cors } from "@elysiajs/cors";
import { staticPlugin } from "@elysiajs/static";

const app = new Elysia({ prefix: "/api/v1" });

app.use(cors())
app.use(staticPlugin())
app.get("/", () => "Hello Elysia")
app.use(FolderController)

app.listen(3000)

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
