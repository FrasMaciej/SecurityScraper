// app.config.ts
import { defineConfig } from "@tanstack/react-start/config";
import tsConfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  vite: {
    plugins: [
      tsConfigPaths({
        projects: ["./tsconfig.json"],
      })
    ],
  },
  server: {
    preset: "aws-lambda",
    serveStatic: true,
    output: {
      publicDir: ".output/server",
    },
  },
});
