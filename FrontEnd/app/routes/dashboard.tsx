import { createFileRoute } from "@tanstack/react-router";
import { Dashboard } from "app/components/dashboard";

export const Route = createFileRoute("/dashboard")({
  component: RouteComponent,
});

function RouteComponent() {
  return <Dashboard />;
}
