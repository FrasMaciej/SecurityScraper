import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { createFileRoute } from "@tanstack/react-router";
import { callLambdaFunction } from "@/api/collector-api";

export const Route = createFileRoute("/dashboard")({
  component: RouteComponent,
});

function RouteComponent() {
  async function getDataFromShodanAPI() {
    await callLambdaFunction();
  }

  return (
    <div className="m-4">
      <div className="grid w-full gap-2">
        <Textarea placeholder="Insert your query to search with Shodan API here - leave blank for test call" />
        <Button onClick={getDataFromShodanAPI}>Send message</Button>
      </div>
    </div>
  );
}
