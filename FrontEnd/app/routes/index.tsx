import { createFileRoute } from "@tanstack/react-router";
import Layout from "@/layout/layout";
export const Route = createFileRoute("/")({
  component: RouteComponent,
});

function RouteComponent() {
  return <Layout />;
}
