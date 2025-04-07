import { createFileRoute } from "@tanstack/react-router";
export const Route = createFileRoute("/")({
  component: RouteComponent,
  loader: () => {
    const data = process.env.SECURITY_SCRAPER_API_GATEWAY_URL;
    return data;
  },
});

function RouteComponent() {
  return (
    <div>
      <h1>Welcome to the dashboard</h1>
    </div>
  );
}
