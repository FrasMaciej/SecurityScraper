import { createFileRoute } from "@tanstack/react-router";
import Dashboard from "@/dashboard/dashboard";
export const Route = createFileRoute("/")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <Dashboard/>
  );
}
