import { createFileRoute } from "@tanstack/react-router";
import { Button } from "@/components/ui/button";
import { Link } from "@tanstack/react-router";
export const Route = createFileRoute("/")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div className="flex flex-col items-center justify-center h-screen">
      <span
        className="text-4xl font-bold
      "
      >
        Hello
      </span>
      <Button>Primary Button</Button>
      <Link to="/dashboard">Dashboard</Link>
    </div>
  );
}
