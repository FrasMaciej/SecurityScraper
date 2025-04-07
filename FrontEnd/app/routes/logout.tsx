import { createFileRoute } from "@tanstack/react-router";
export const Route = createFileRoute("/logout")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div>
      <h1>You are logout</h1>
    </div>
  );
}
